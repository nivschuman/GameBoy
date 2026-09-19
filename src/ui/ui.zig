const std = @import("std");
const GameBoy = @import("../gameboy/gameboy.zig").GameBoy;
const UiError = @import("../errors/errors.zig").UiError;
const tiles = @import("../ppu/vram/tiles/tiles.zig");
const time = @import("../utils/time/time.zig");
const constants = @import("../constants/constants.zig");
const c = @cImport({
    @cInclude("SDL.h");
});

const logger = std.log.scoped(.ui);

pub const Ui = struct {
    windows: std.ArrayList(GameBoyWindow),
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator) !Ui {
        if (c.SDL_Init(c.SDL_INIT_VIDEO) != 0) {
            return UiError.SdlInitFailed;
        }

        return .{
            .allocator = allocator,
            .windows = .empty,
        };
    }

    pub fn deinit(self: *Ui) void {
        for (self.windows.items) |*win| {
            win.deinit();
        }
        self.windows.deinit(self.allocator);
        c.SDL_Quit();
    }

    pub fn createGameBoyWindow(self: *Ui, title: [*c]const u8, icon: ?*const Icon, gameboy: *GameBoy, debug: bool) !void {
        const window = try GameBoyWindow.init(title, icon, gameboy, debug);
        try self.windows.append(self.allocator, window);
    }

    pub fn run(self: *Ui) void {
        var event: c.SDL_Event = undefined;
        while (self.windows.items.len > 0) {
            while (c.SDL_PollEvent(&event) != 0) {
                if (event.type == c.SDL_WINDOWEVENT and event.window.event == c.SDL_WINDOWEVENT_CLOSE) {
                    for (self.windows.items) |*win| {
                        if (win.getId() == event.window.windowID) {
                            win.closed = true;
                        }
                    }
                }
            }

            for (self.windows.items) |*win| {
                if (!win.closed) {
                    win.renderFrame() catch |err| {
                        logger.err("{s}", .{@errorName(err)});
                    };
                }
            }

            var i: usize = 0;
            while (i < self.windows.items.len) {
                if (self.windows.items[i].closed) {
                    self.windows.items[i].deinit();
                    _ = self.windows.swapRemove(i);
                } else {
                    i += 1;
                }
            }
        }
    }

    pub fn delayer() time.Delayer {
        return time.Delayer.init(delay);
    }

    pub fn stopwatch() time.Stopwatch {
        return time.Stopwatch.init(getTicks);
    }

    pub fn getTicks() time.Milliseconds {
        return c.SDL_GetTicks();
    }

    pub fn delay(milliseconds: time.Milliseconds) void {
        c.SDL_Delay(milliseconds);
    }
};

pub const WindowId = u32;

pub const GameBoyWindow = struct {
    const SCALE = 3;
    const WINDOW_WIDTH = constants.SCREEN_WIDTH * SCALE;
    const WINDOW_HEIGHT = constants.SCREEN_HEIGHT * SCALE;
    const DEBUG_WINDOW_WIDTH = 16 * 8 * SCALE;
    const DEBUG_WINDOW_HEIGHT = 32 * 8 * SCALE;
    const DEBUG_TEXTURE_WIDTH = (16 * 8 * SCALE) + (16 * SCALE);
    const DEBUG_TEXTURE_HEIGHT = (32 * 8 * SCALE) + (64 * SCALE);
    const DEBUG_SURFACE_WIDTH = (16 * 8 * SCALE) + (16 * SCALE);
    const DEBUG_SURFACE_HEIGHT = (32 * 8 * SCALE) + (64 * SCALE);

    window: Window,
    renderer: Renderer,
    surface: Surface,
    texture: Texture,
    closed: bool,
    debug: bool,
    gameboy: *GameBoy,
    previous_frame: u32,

    pub fn init(title: [*c]const u8, icon: ?*const Icon, gameboy: *GameBoy, debug: bool) !GameBoyWindow {
        const width: c_int = if (!debug) WINDOW_WIDTH else DEBUG_WINDOW_WIDTH;
        const height: c_int = if (!debug) WINDOW_HEIGHT else DEBUG_WINDOW_HEIGHT;

        const window = try Window.init(title, width, height);
        const renderer = try window.createRenderer();

        const surface = if (debug) try Surface.init(DEBUG_SURFACE_WIDTH, DEBUG_SURFACE_HEIGHT) else try Surface.init(WINDOW_WIDTH, WINDOW_HEIGHT);
        const texture = if (debug) try renderer.createTexture(DEBUG_TEXTURE_WIDTH, DEBUG_TEXTURE_HEIGHT) else try renderer.createTexture(WINDOW_WIDTH, WINDOW_HEIGHT);

        if (icon) |i| {
            i.attach(&window);
        }

        return .{
            .window = window,
            .renderer = renderer,
            .surface = surface,
            .texture = texture,
            .closed = false,
            .debug = debug,
            .gameboy = gameboy,
            .previous_frame = 0,
        };
    }

    pub fn deinit(self: *GameBoyWindow) void {
        self.surface.deinit();
        self.texture.deinit();
        self.renderer.deinit();
        self.window.deinit();
    }

    pub fn getId(self: *const GameBoyWindow) WindowId {
        return self.window.getId();
    }

    pub fn renderFrame(self: *GameBoyWindow) !void {
        if (self.previous_frame != self.gameboy.ppu.current_frame) {
            if (self.debug) {
                try self.renderTiles();
            } else {
                try self.renderVideoBuffer();
            }
        }

        self.previous_frame = self.gameboy.ppu.current_frame;
    }

    pub fn renderVideoBuffer(self: *GameBoyWindow) !void {
        var rect = c.struct_SDL_Rect{};

        for (0..constants.SCREEN_HEIGHT) |y| {
            for (0..constants.SCREEN_WIDTH) |x| {
                rect.x = @as(c_int, @intCast(x)) * SCALE;
                rect.y = @as(c_int, @intCast(y)) * SCALE;
                rect.w = SCALE;
                rect.h = SCALE;

                const color = self.gameboy.ppu.pixel_fetcher.video_buffer[x + y * constants.SCREEN_WIDTH];
                try self.surface.fillRect(&rect, color.getUiColor());
            }
        }

        try self.present();
    }

    pub fn renderTiles(self: *GameBoyWindow) !void {
        try self.surface.fill(0xFF111111);

        const tile_columns: c_int = 16;
        const tile_size: c_int = 8;
        const all_tiles = self.gameboy.ppu.vram.getTiles();
        for (all_tiles, 0..) |tile, tile_index| {
            const idx: c_int = @intCast(tile_index);
            const x_index: c_int = @mod(idx, tile_columns);
            const y_index: c_int = @divTrunc(idx, tile_columns);
            const x: c_int = x_index * SCALE + x_index * tile_size * SCALE;
            const y: c_int = 16 + y_index * SCALE + y_index * tile_size * SCALE;
            try self.surface.displayTile(tile, x, y, SCALE);
        }

        try self.present();
    }

    pub fn present(self: *GameBoyWindow) !void {
        try self.texture.update(self.surface);
        try self.renderer.clear();
        try self.renderer.copy(self.texture);
        self.renderer.present();
    }
};

pub const Window = struct {
    window: *c.struct_SDL_Window,

    pub fn init(title: [*c]const u8, width: c_int, height: c_int) !Window {
        const window = c.SDL_CreateWindow(title, c.SDL_WINDOWPOS_CENTERED, c.SDL_WINDOWPOS_CENTERED, width, height, 0) orelse return UiError.WindowCreationFailed;
        return .{ .window = window };
    }

    pub fn deinit(self: *Window) void {
        c.SDL_DestroyWindow(self.window);
    }

    pub fn getId(self: *const Window) WindowId {
        return c.SDL_GetWindowID(self.window);
    }

    pub fn createRenderer(self: *const Window) !Renderer {
        const renderer = c.SDL_CreateRenderer(self.window, -1, 0);
        if (renderer) |r| {
            return .{ .renderer = r };
        }

        return UiError.RendererCreationFailed;
    }
};

pub const Renderer = struct {
    renderer: *c.struct_SDL_Renderer,

    pub fn deinit(self: *Renderer) void {
        c.SDL_DestroyRenderer(self.renderer);
    }

    pub fn clear(self: *Renderer) !void {
        const err = c.SDL_RenderClear(self.renderer);
        if (err != 0) {
            return UiError.RenderClearFailed;
        }
    }

    pub fn present(self: *Renderer) void {
        c.SDL_RenderPresent(self.renderer);
    }

    pub fn drawColor(self: *Renderer, red: u8, green: u8, blue: u8, alpha: u8) !void {
        const err = c.SDL_SetRenderDrawColor(self.renderer, red, green, blue, alpha);
        if (err != 0) {
            return UiError.RenderDrawColorFailed;
        }
    }

    pub fn copy(self: *Renderer, texture: Texture) !void {
        const err = c.SDL_RenderCopy(self.renderer, texture.texture, null, null);
        if (err != 0) {
            return UiError.RenderCopyFailed;
        }
    }

    pub fn createTexture(self: *const Renderer, width: c_int, height: c_int) !Texture {
        const texture = c.SDL_CreateTexture(self.renderer, c.SDL_PIXELFORMAT_ARGB8888, c.SDL_TEXTUREACCESS_STREAMING, width, height);
        if (texture) |t| {
            return .{ .texture = t };
        }

        return UiError.TextureCreationFailed;
    }
};

pub const Icon = struct {
    surface: *c.struct_SDL_Surface,

    pub fn init(bytes: []const u8) Icon {
        const rw = c.SDL_RWFromConstMem(bytes.ptr, @intCast(bytes.len));
        const surface = c.SDL_LoadBMP_RW(rw, 1);
        return .{
            .surface = surface,
        };
    }

    pub fn deinit(self: *Icon) void {
        c.SDL_FreeSurface(self.surface);
    }

    pub fn attach(self: *const Icon, window: *const Window) void {
        c.SDL_SetWindowIcon(window.window, self.surface);
    }
};

pub const Surface = struct {
    const TILE_COLORS = [_]u32{ 0xFFFFFFFF, 0xFFAAAAAA, 0xFF555555, 0xFF000000 };

    surface: *c.struct_SDL_Surface,

    pub fn init(width: c_int, height: c_int) !Surface {
        const surface = c.SDL_CreateRGBSurface(0, width, height, 32, 0x00FF0000, 0x0000FF00, 0x000000FF, 0xFF000000);
        if (surface) |s| {
            return .{ .surface = s };
        }

        return UiError.SurfaceCreationFailed;
    }

    pub fn deinit(self: *Surface) void {
        c.SDL_FreeSurface(self.surface);
    }

    pub fn fill(self: *Surface, color: u32) !void {
        const rect = c.struct_SDL_Rect{
            .x = 0,
            .y = 0,
            .w = self.surface.w,
            .h = self.surface.h,
        };

        try self.fillRect(&rect, color);
    }

    pub fn fillRect(self: *Surface, rect: *const c.struct_SDL_Rect, color: u32) !void {
        const err = c.SDL_FillRect(self.surface, rect, color);
        if (err != 0) {
            return UiError.FillRectFailed;
        }
    }

    pub fn displayTile(self: *Surface, tile: tiles.Tile, x: c_int, y: c_int, scale: comptime_int) !void {
        const rows = tile.getRows();
        for (rows, 0..) |row, row_index| {
            const pixels = row.getPixels();
            for (pixels, 0..) |pixel, pixel_index| {
                var rect = c.struct_SDL_Rect{};
                rect.x = x + @as(c_int, @intCast(pixel_index)) * scale;
                rect.y = y + @as(c_int, @intCast(row_index)) * scale;
                rect.w = scale;
                rect.h = scale;
                try self.fillRect(&rect, TILE_COLORS[pixel.bytes]);
            }
        }
    }
};

pub const Texture = struct {
    texture: *c.struct_SDL_Texture,

    pub fn deinit(self: *Texture) void {
        c.SDL_DestroyTexture(self.texture);
    }

    pub fn update(self: *Texture, surface: Surface) !void {
        const err = c.SDL_UpdateTexture(self.texture, null, surface.surface.pixels, surface.surface.pitch);
        if (err != 0) {
            return UiError.UpdateTextureFailed;
        }
    }
};
