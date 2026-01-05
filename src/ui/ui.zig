const std = @import("std");
const GameBoy = @import("../gameboy/gameboy.zig").GameBoy;
const UiError = @import("../errors/errors.zig").UiError;
const tiles = @import("../ppu/vram/tiles/tiles.zig");
const c = @cImport({
    @cInclude("SDL.h");
});

const logger = std.log.scoped(.ui);

pub const Ui = struct {
    windows: std.ArrayList(GameBoyWindow),
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator) !Ui {
        _ = c.SDL_Init(c.SDL_INIT_VIDEO);
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

    pub fn createGameBoyWindow(self: *Ui, title: [*c]const u8, gameboy: *GameBoy, debug: bool) !WindowId {
        const window = try GameBoyWindow.init(title, gameboy, debug);
        try self.windows.append(self.allocator, window);
        return window.id;
    }

    pub fn run(self: *Ui) void {
        var event: c.SDL_Event = undefined;
        while (self.windows.items.len > 0) {
            while (c.SDL_PollEvent(&event) != 0) {
                if (event.type == c.SDL_WINDOWEVENT and event.window.event == c.SDL_WINDOWEVENT_CLOSE) {
                    for (self.windows.items) |*win| {
                        if (win.id == event.window.windowID) {
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

            c.SDL_Delay(16);
        }
    }
};

pub const WindowId = u32;

pub const GameBoyWindow = struct {
    const SCALE = 4;
    const SCREEN_WIDTH = 1024;
    const SCREEN_HEIGHT = 768;

    id: WindowId,
    title: [*c]const u8,
    window: *c.struct_SDL_Window,
    renderer: Renderer,
    surface: ?Surface,
    texture: ?Texture,
    closed: bool,
    debug: bool,
    gameboy: *GameBoy,

    pub fn init(title: [*c]const u8, gameboy: *GameBoy, debug: bool) !GameBoyWindow {
        const width: c_int = if (!debug) SCREEN_WIDTH else 16 * 8 * SCALE;
        const height: c_int = if (!debug) SCREEN_HEIGHT else 32 * 8 * SCALE;
        const window = c.SDL_CreateWindow(title, c.SDL_WINDOWPOS_CENTERED, c.SDL_WINDOWPOS_CENTERED, width, height, 0);
        if (window) |w| {
            const id = c.SDL_GetWindowID(w);
            const renderer = try Renderer.init(w);
            const surface = if (debug) try Surface.init(SCALE) else null;
            const texture = if (debug) try Texture.init(renderer.renderer, SCALE) else null;
            return .{
                .id = id,
                .title = title,
                .window = w,
                .renderer = renderer,
                .surface = surface,
                .texture = texture,
                .closed = false,
                .debug = debug,
                .gameboy = gameboy,
            };
        }

        return UiError.WindowCreationFailed;
    }

    pub fn deinit(self: *GameBoyWindow) void {
        if (self.texture) |*t| {
            t.deinit();
        }
        if (self.surface) |*s| {
            s.deinit();
        }
        self.renderer.deinit();
        c.SDL_DestroyWindow(self.window);
    }

    pub fn renderFrame(self: *GameBoyWindow) !void {
        if (self.debug) {
            try self.renderTiles(SCALE);
        } else {
            try self.renderer.renderFrame();
        }
    }

    pub fn renderTiles(self: *GameBoyWindow, scale: comptime_int) !void {
        if (self.surface) |*s| {
            var rect = c.struct_SDL_Rect{};
            rect.x = 0;
            rect.y = 0;
            rect.w = s.surface.w;
            rect.h = s.surface.h;
            try s.fillRect(&rect, 0xFF111111);

            const tile_columns: c_int = 16;
            const tile_size: c_int = 8;
            const all_tiles = self.gameboy.ppu.vram.getTiles();
            for (all_tiles, 0..) |tile, tile_index| {
                const idx: c_int = @intCast(tile_index);
                const x_index: c_int = @mod(idx, tile_columns);
                const y_index: c_int = @divTrunc(idx, tile_columns);
                const x: c_int = x_index * scale + x_index * tile_size * scale;
                const y: c_int = y_index * scale + y_index * tile_size * scale;
                try s.displayTile(tile, x, y, scale);
            }

            if (self.texture) |*t| {
                try t.update(s.*);
                try self.renderer.clear();
                try self.renderer.copy(t.*);
                self.renderer.present();
            }
        }
    }
};

pub const Renderer = struct {
    renderer: *c.struct_SDL_Renderer,

    pub fn init(window: *c.struct_SDL_Window) !Renderer {
        const renderer = c.SDL_CreateRenderer(window, -1, 0);
        if (renderer) |r| {
            return .{ .renderer = r };
        }

        return UiError.RendererCreationFailed;
    }

    pub fn deinit(self: *Renderer) void {
        c.SDL_DestroyRenderer(self.renderer);
    }

    pub fn renderFrame(self: *Renderer) !void {
        try self.drawColor(0, 0, 0, 255);
        try self.clear();
        self.present();
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
};

pub const Surface = struct {
    const TILE_COLORS = [_]u32{ 0xFFFFFFFF, 0xFFAAAAAA, 0xFF555555, 0xFF000000 };

    surface: *c.struct_SDL_Surface,

    pub fn init(scale: comptime_int) !Surface {
        const surface = c.SDL_CreateRGBSurface(0, (16 * 8 * scale) + (16 * scale), (32 * 8 * scale) + (64 * scale), 32, 0x00FF0000, 0x0000FF00, 0x000000FF, 0xFF000000);
        if (surface) |s| {
            return .{ .surface = s };
        }

        return UiError.SurfaceCreationFailed;
    }

    pub fn deinit(self: *Surface) void {
        c.SDL_FreeSurface(self.surface);
    }

    pub fn fillRect(self: *Surface, rect: *c.struct_SDL_Rect, color: u32) !void {
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

    pub fn init(renderer: *c.struct_SDL_Renderer, scale: comptime_int) !Texture {
        const texture = c.SDL_CreateTexture(renderer, c.SDL_PIXELFORMAT_ARGB8888, c.SDL_TEXTUREACCESS_STREAMING, (16 * 8 * scale) + (16 * scale), (32 * 8 * scale) + (64 * scale));
        if (texture) |t| {
            return .{ .texture = t };
        }

        return UiError.TextureCreationFailed;
    }

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
