const std = @import("std");
const c = @cImport({
    @cInclude("SDL.h");
});

pub const SDL = struct {
    windows: std.ArrayList(SDLWindow),
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator) !SDL {
        _ = c.SDL_Init(c.SDL_INIT_VIDEO);
        return .{
            .allocator = allocator,
            .windows = .empty,
        };
    }

    pub fn deinit(self: *SDL) void {
        for (self.windows.items) |*win| {
            win.deinit();
        }
        self.windows.deinit(self.allocator);
        c.SDL_Quit();
    }

    pub fn createWindow(self: *SDL, title: [*c]const u8) !SDLWindow {
        const win = SDLWindow.init(title);
        try self.windows.append(self.allocator, win);
        return win;
    }

    pub fn run(self: *SDL) void {
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
                    win.renderer.clearAndPresent();
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

pub const SDLWindow = struct {
    id: u32,
    title: [*c]const u8,
    window: ?*c.struct_SDL_Window,
    renderer: SDLRenderer,
    closed: bool,

    pub fn init(title: [*c]const u8) SDLWindow {
        const window = c.SDL_CreateWindow(title, c.SDL_WINDOWPOS_CENTERED, c.SDL_WINDOWPOS_CENTERED, 640, 400, 0);
        const id = c.SDL_GetWindowID(window);
        const renderer = SDLRenderer.init(window);
        return .{
            .id = id,
            .title = title,
            .window = window,
            .renderer = renderer,
            .closed = false,
        };
    }

    pub fn deinit(self: *SDLWindow) void {
        self.renderer.deinit();
        c.SDL_DestroyWindow(self.window);
    }
};

pub const SDLRenderer = struct {
    renderer: ?*c.struct_SDL_Renderer,

    pub fn init(window: ?*c.struct_SDL_Window) SDLRenderer {
        const renderer = c.SDL_CreateRenderer(window, 0, c.SDL_RENDERER_PRESENTVSYNC);
        return .{ .renderer = renderer };
    }

    pub fn deinit(self: *SDLRenderer) void {
        c.SDL_DestroyRenderer(self.renderer);
    }

    pub fn clearAndPresent(self: *SDLRenderer) void {
        _ = c.SDL_SetRenderDrawColor(self.renderer, 0, 0, 0, 255);
        _ = c.SDL_RenderClear(self.renderer);
        c.SDL_RenderPresent(self.renderer);
    }
};
