const constants = @import("../../constants/constants.zig");
const Pixel = @import("../vram/tiles/tiles.zig").Pixel;
const TileRow = @import("../vram/tiles/tiles.zig").TileRow;
const Palette = @import("../../io/lcd/palette/palette.zig").Palette;
const Color = @import("../../io/lcd/palette/palette.zig").Color;
const Queue = @import("../../utils/structures/structures.zig").Queue;
const VRam = @import("../vram/vram.zig").VRam;
const Lcd = @import("../../io/lcd/lcd.zig").Lcd;
const Tick = @import("../../cycles/cycles.zig").Tick;

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
    pub const TICKS_PER_GET_TILE_MODE = 2;
    pub const TICKS_PER_GET_TILE_DATA_LOW_MODE = 2;
    pub const TICKS_PER_GET_TILE_DATA_HIGH_MODE = 2;
    pub const TICKS_PER_SLEEP_MODE = 2;

    background_pixel_fifo: *PixelFifo,
    object_pixel_fifo: *PixelFifo,
    vram: *VRam,
    lcd: *Lcd,
    mode: PixelFetcherMode,
    ticks: Tick,
    fetch_type: FetchType,
    fetcher_x: u5,
    window_line_counter: u8,
    increment_window_line_counter: bool,
    render_x: u8,
    tile_number: u8,
    tile_data_low: u8,
    tile_data_high: u8,
    discard_pixels: u8, //discard pixels of the first tile which aren't on the screen
    video_buffer: [constants.SCREEN_WIDTH * constants.SCREEN_HEIGHT]Color, //pixels to display

    pub fn init(background_pixel_fifo: *PixelFifo, object_pixel_fifo: *PixelFifo, vram: *VRam, lcd: *Lcd) PixelFetcher {
        return .{
            .background_pixel_fifo = background_pixel_fifo,
            .object_pixel_fifo = object_pixel_fifo,
            .vram = vram,
            .lcd = lcd,
            .mode = .GET_TILE,
            .ticks = 0,
            .fetch_type = .BACKGROUND,
            .fetcher_x = 0,
            .window_line_counter = 0,
            .increment_window_line_counter = false,
            .render_x = 0,
            .tile_number = 0,
            .tile_data_low = 0,
            .tile_data_high = 0,
            .discard_pixels = 0,
            .video_buffer = [_]Color{.WHITE} ** (constants.SCREEN_WIDTH * constants.SCREEN_HEIGHT),
        };
    }

    pub fn getTile(self: *PixelFetcher) void {
        if (self.ticks < TICKS_PER_GET_TILE_MODE) {
            return;
        }

        if (self.lcd.getBackgroundAndWindowPriority() == 0) {
            self.tile_number = 0xFF;
            self.mode = .GET_TILE_DATA_LOW;
            self.ticks = 0;
            return;
        }

        //background: x = (scx/8 + fetcher_x) modulo 32, y = ((scy+ly) modulo 256) / 8
        //window: x = fetcher_x, y = window_line_counter / 8
        const tile_map_x: u5 = if (self.fetch_type == .BACKGROUND) @truncate((self.lcd.scx / 8 + self.fetcher_x)) else self.fetcher_x;
        const tile_map_y: u5 = if (self.fetch_type == .BACKGROUND) @truncate((self.lcd.scy +% self.lcd.ly) / 8) else @truncate(self.window_line_counter / 8);
        self.tile_number = self.vram.getTileNumber(self.lcd.getBackgroundTileMap(), tile_map_x, tile_map_y);
        self.mode = .GET_TILE_DATA_LOW;
        self.ticks = 0;
    }

    pub fn getTileDataLow(self: *PixelFetcher) void {
        if (self.ticks < TICKS_PER_GET_TILE_DATA_LOW_MODE) {
            return;
        }

        const tile_row: u3 = if (self.fetch_type == .BACKGROUND) @truncate((self.lcd.scy +% self.lcd.ly) % 8) else @truncate(self.window_line_counter % 8);
        self.tile_data_low = self.vram.getTileDataLow(self.lcd.getTileData(), self.tile_number, tile_row);
        self.mode = .GET_TILE_DATA_HIGH;
        self.ticks = 0;
    }

    pub fn getTileDataHigh(self: *PixelFetcher) void {
        if (self.ticks < TICKS_PER_GET_TILE_DATA_HIGH_MODE) {
            return;
        }

        const tile_row: u3 = if (self.fetch_type == .BACKGROUND) @truncate((self.lcd.scy +% self.lcd.ly) % 8) else @truncate(self.window_line_counter % 8);
        self.tile_data_high = self.vram.getTileDataHigh(self.lcd.getTileData(), self.tile_number, tile_row);
        self.mode = .SLEEP;
        self.ticks = 0;
    }

    pub fn sleep(self: *PixelFetcher) void {
        if (self.ticks < TICKS_PER_SLEEP_MODE) {
            return;
        }

        self.mode = .PUSH;
        self.ticks = 0;
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
        self.ticks = 0;
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

        self.video_buffer[@as(usize, self.render_x) + @as(usize, self.lcd.ly) * constants.SCREEN_WIDTH] = pixel_fifo_entry.palette.getColor(pixel_fifo_entry.pixel);
        self.render_x += 1;
    }

    pub fn tick(self: *PixelFetcher) void {
        self.ticks += 1;
        switch (self.mode) {
            .GET_TILE => self.getTile(),
            .GET_TILE_DATA_LOW => self.getTileDataLow(),
            .GET_TILE_DATA_HIGH => self.getTileDataHigh(),
            .SLEEP => self.sleep(),
            .PUSH => self.push(),
        }
        self.renderPixel();
    }

    pub fn reset(self: *PixelFetcher) void {
        self.background_pixel_fifo.clear();
        self.fetch_type = .BACKGROUND;
        self.mode = .GET_TILE;
        self.ticks = 0;
        self.fetcher_x = 0;
        self.render_x = 0;
        self.discard_pixels = self.lcd.scx % 8;
    }
};
