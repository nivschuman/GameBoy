const Pixel = @import("../vram/tiles/tiles.zig").Pixel;
const TileRow = @import("../vram/tiles/tiles.zig").TileRow;
const Palette = @import("../../io/lcd/palette/palette.zig").Palette;
const Color = @import("../../io/lcd/palette/palette.zig").Color;
const Queue = @import("../../utils/structures/structures.zig").Queue;
const VRam = @import("../vram/vram.zig").VRam;
const Lcd = @import("../../io/lcd/lcd.zig").Lcd;

const FetchType = enum { BACKGROUND, WINDOW };

pub const PixelFifoEntry = struct {
    pixel: Pixel,
    palette: Palette,
    sprite_priority: u1,
    background_priority: u1,

    pub fn init(pixel: Pixel, palette: Palette, sprite_priority: u1, background_priority: u1) PixelFifoEntry {
        return .{
            .pixel = pixel,
            .palette = palette,
            .sprite_priority = sprite_priority,
            .background_priority = background_priority,
        };
    }
};

pub const PixelFifo = Queue(PixelFifoEntry, 8);

pub const PixelFetcherMode = enum { GET_TILE, GET_TILE_DATA_LOW, GET_TILE_DATA_HIGH, SLEEP, PUSH };

pub const PixelFetcher = struct {
    const SCREEN_WIDTH = 160;
    const SCREEN_HEIGHT = 144;

    background_pixel_fifo: *PixelFifo,
    object_pixel_fifo: *PixelFifo,
    vram: *VRam,
    lcd: *Lcd,
    mode: PixelFetcherMode,
    fetch_type: FetchType,
    fetcher_x: u8, //current x of tile to fetch
    window_line_counter: u8, //incremented each time a scanline had any window pixels on it and reset when entering VBlank mode
    increment_window_line_counter: bool, //whether to increment window line counter in hblank mode
    render_x: u8, //current screen x coordinate to render
    tile_number: u8,
    tile_data_low: u8,
    tile_data_high: u8,
    discard_pixels: u8, //discard pixels of the first tile which aren't on the screen
    video_buffer: [SCREEN_WIDTH * SCREEN_HEIGHT]Color, //pixels to display

    pub fn init(background_pixel_fifo: *PixelFifo, object_pixel_fifo: *PixelFifo, vram: *VRam, lcd: *Lcd) PixelFetcher {
        return .{
            .background_pixel_fifo = background_pixel_fifo,
            .object_pixel_fifo = object_pixel_fifo,
            .vram = vram,
            .lcd = lcd,
            .mode = .GET_TILE,
            .fetch_type = .BACKGROUND,
            .fetcher_x = 0,
            .window_line_counter = 0,
            .increment_window_line_counter = false,
            .render_x = 0,
            .tile_number = 0,
            .tile_data_low = 0,
            .tile_data_high = 0,
            .discard_pixels = 0,
            .video_buffer = [_]Color{.WHITE} ** (SCREEN_WIDTH * SCREEN_HEIGHT),
        };
    }

    pub fn getTile(self: *PixelFetcher) void {
        if (self.lcd.getBackgroundAndWindowPriority() == 0) {
            self.tile_number = 0xFF;
            self.mode = .GET_TILE_DATA_LOW;
            return;
        }

        //background: x = (scx/8 + fetcher_x) modulo 32, y = ((scy+ly) modulo 256) / 8
        //window: x = fetcher_x, y = window_line_counter / 8
        const tile_map_x: u16 = if (self.fetch_type == .BACKGROUND) (@divTrunc(self.lcd.scx, 8) + self.fetcher_x) & 0x1F else self.fetcher_x;
        const tile_map_y: u16 = if (self.fetch_type == .BACKGROUND) @divTrunc((self.lcd.scy + self.lcd.ly) & 0xFF, 8) else @divTrunc(self.window_line_counter, 8);
        self.tile_number = self.vram.readByte(self.lcd.getBackgroundTileMap().getAddress() + tile_map_x + tile_map_y * 32);
        self.mode = .GET_TILE_DATA_LOW;
    }

    pub fn getTileDataLow(self: *PixelFetcher) void {
        const tile_address = self.lcd.getTileData().getTileAddress(self.tile_number);
        const tile_row = if (self.fetch_type == .BACKGROUND) (self.lcd.scy + self.lcd.ly) % 8 else self.window_line_counter % 8;
        self.tile_data_low = self.vram.readByte(tile_address + tile_row * 2); //each tile row is two bytes
        self.mode = .GET_TILE_DATA_HIGH;
    }

    pub fn getTileDataHigh(self: *PixelFetcher) void {
        const tile_address = self.lcd.getTileData().getTileAddress(self.tile_number);
        const tile_row = if (self.fetch_type == .BACKGROUND) (self.lcd.scy + self.lcd.ly) % 8 else self.window_line_counter % 8;
        self.tile_data_high = self.vram.readByte(tile_address + tile_row * 2 + 1); //each tile row is two bytes
        self.mode = .SLEEP;
    }

    pub fn sleep(self: *PixelFetcher) void {
        self.mode = .PUSH;
    }

    pub fn push(self: *PixelFetcher) void {
        if (!self.background_pixel_fifo.isEmpty()) {
            return;
        }

        const tile_row = TileRow.init(@as(u16, self.tile_data_low) | (@as(u16, self.tile_data_high) << 8));
        for (tile_row.getPixels()) |pixel| {
            self.background_pixel_fifo.enqueue(.{
                .pixel = pixel,
                .palette = self.lcd.bgp,
                .sprite_priority = 0,
                .background_priority = 0,
            });
        }

        self.fetcher_x += 1;
        self.mode = .GET_TILE;
    }

    pub fn renderPixel(self: *PixelFetcher) void {
        //hit window, need to fetch window tiles instead
        if (self.fetch_type == .BACKGROUND and self.lcd.getWindowEnable() == 1 and self.lcd.ly >= self.lcd.wy and self.render_x >= self.lcd.wx - 7) {
            self.background_pixel_fifo.clear();
            self.fetch_type = .WINDOW;
            self.mode = .GET_TILE;
            self.fetcher_x = 0;
            self.increment_window_line_counter = true;
            return;
        }

        const pixel_fifo_entry = self.background_pixel_fifo.dequeue() orelse return;

        if (self.discard_pixels > 0 and self.fetch_type != .WINDOW) {
            self.discard_pixels -= 1;
            return;
        }

        self.video_buffer[@as(usize, self.render_x) + @as(usize, self.lcd.ly) * SCREEN_WIDTH] = pixel_fifo_entry.palette.getColor(pixel_fifo_entry.pixel);
        self.render_x += 1;
    }

    pub fn step(self: *PixelFetcher) void {
        switch (self.mode) {
            .GET_TILE => self.getTile(),
            .GET_TILE_DATA_LOW => self.getTileDataLow(),
            .GET_TILE_DATA_HIGH => self.getTileDataHigh(),
            .SLEEP => self.sleep(),
            .PUSH => self.push(),
        }
    }

    pub fn reset(self: *PixelFetcher) void {
        self.background_pixel_fifo.clear();
        self.fetch_type = .BACKGROUND;
        self.mode = .GET_TILE;
        self.fetcher_x = 0;
        self.render_x = 0;
        self.discard_pixels = self.lcd.scx % 8;
    }
};
