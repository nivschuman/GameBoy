const std = @import("std");
const c = @cImport({
    @cInclude("SDL.h");
});

pub fn init() void {
    _ = c.SDL_Init(c.SDL_INIT_VIDEO);
}

pub fn deinit() void {
    c.SDL_Quit();
}

pub fn createWindow(title: [*c]const u8) SDLWindow {
    return SDLWindow.init(title);
}

pub const SDLWindow = struct {
    title: [*c]const u8,
    window: ?*c.struct_SDL_Window,
    renderer: SDLRenderer,
    running: bool,

    pub fn init(title: [*c]const u8) SDLWindow {
        const window = c.SDL_CreateWindow(title, c.SDL_WINDOWPOS_CENTERED, c.SDL_WINDOWPOS_CENTERED, 640, 400, 0);
        const r = SDLRenderer.init(window);
        return .{
            .title = title,
            .window = window,
            .renderer = r,
            .running = false,
        };
    }

    pub fn deinit(self: *SDLWindow) void {
        self.renderer.deinit();
        c.SDL_DestroyWindow(self.window);
    }

    pub fn run(self: *SDLWindow) void {
        var event: c.SDL_Event = undefined;
        self.running = true;
        while (self.running) {
            while (c.SDL_PollEvent(&event) != 0) {
                switch (event.type) {
                    c.SDL_QUIT => self.running = false,
                    else => {},
                }
            }

            self.renderer.clearAndPresent();
            c.SDL_Delay(16);
        }
    }
};

pub const SDLRenderer = struct {
    renderer: ?*c.struct_SDL_Renderer,

    pub fn init(window: ?*c.struct_SDL_Window) SDLRenderer {
        const r = c.SDL_CreateRenderer(window, 0, c.SDL_RENDERER_PRESENTVSYNC);
        return .{ .renderer = r };
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
