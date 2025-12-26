const std = @import("std");
const GameBoy = @import("../gameboy/gameboy.zig").GameBoy;
const UiError = @import("../errors/errors.zig").UiError;
const c = @cImport({
    @cInclude("SDL.h");
});

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

    pub fn createGameBoyWindow(self: *Ui, title: [*c]const u8, gameboy: *GameBoy) !WindowId {
        const window = try GameBoyWindow.init(title, gameboy);
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
                    win.renderFrame();
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
    id: WindowId,
    title: [*c]const u8,
    window: *c.struct_SDL_Window,
    renderer: Renderer,
    closed: bool,
    gameboy: *GameBoy,

    pub fn init(title: [*c]const u8, gameboy: *GameBoy) !GameBoyWindow {
        const window = c.SDL_CreateWindow(title, c.SDL_WINDOWPOS_CENTERED, c.SDL_WINDOWPOS_CENTERED, 640, 400, 0);
        if (window) |w| {
            const id = c.SDL_GetWindowID(window);
            const renderer = try Renderer.init(window);
            return .{
                .id = id,
                .title = title,
                .window = w,
                .renderer = renderer,
                .closed = false,
                .gameboy = gameboy,
            };
        }

        return UiError.WindowCreationFailed;
    }

    pub fn deinit(self: *GameBoyWindow) void {
        self.renderer.deinit();
        c.SDL_DestroyWindow(self.window);
    }

    pub fn renderFrame(self: *GameBoyWindow) void {
        self.renderer.renderFrame();
    }
};

pub const Renderer = struct {
    renderer: *c.struct_SDL_Renderer,

    pub fn init(window: ?*c.struct_SDL_Window) !Renderer {
        const renderer = c.SDL_CreateRenderer(window, 0, c.SDL_RENDERER_PRESENTVSYNC);
        if (renderer) |r| {
            return .{ .renderer = r };
        }

        return UiError.RendererCreationFailed;
    }

    pub fn deinit(self: *Renderer) void {
        c.SDL_DestroyRenderer(self.renderer);
    }

    pub fn renderFrame(self: *Renderer) void {
        _ = c.SDL_SetRenderDrawColor(self.renderer, 0, 0, 0, 255);
        _ = c.SDL_RenderClear(self.renderer);
        c.SDL_RenderPresent(self.renderer);
    }
};
