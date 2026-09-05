const Pixel = @import("../../../ppu/vram/tiles/tiles.zig").Pixel;

pub const Color = enum(u2) {
    WHITE = 0,
    LIGHT_GRAY = 1,
    DARK_GRAY = 2,
    BLACK = 3,

    pub fn getUiColor(self: Color) u32 {
        return switch (self) {
            .WHITE => 0xFF000000,
            .LIGHT_GRAY => 0xFF555555,
            .DARK_GRAY => 0xFFAAAAAA,
            .BLACK => 0xFFFFFFFF,
        };
    }
};

pub const PaletteType = enum { OBJECT, BACKGROUND };

pub const Palette = struct {
    colors: [4]Color,
    palette_type: PaletteType,

    pub fn init(value: u8, palette_type: PaletteType) Palette {
        var palette: Palette = .{
            .colors = [_]Color{ Color.BLACK, Color.DARK_GRAY, Color.LIGHT_GRAY, Color.WHITE },
            .palette_type = palette_type,
        };
        palette.setValue(value);
        return palette;
    }

    pub fn getValue(self: *const Palette) u8 {
        const color0 = @as(u8, @intFromEnum(self.colors[0])) << 0;
        const color1 = @as(u8, @intFromEnum(self.colors[1])) << 2;
        const color2 = @as(u8, @intFromEnum(self.colors[2])) << 4;
        const color3 = @as(u8, @intFromEnum(self.colors[3])) << 6;
        return color0 | color1 | color2 | color3;
    }

    pub fn setValue(self: *Palette, value: u8) void {
        const v = if (self.palette_type == .BACKGROUND) value else value & 0xFC;
        self.colors[0] = @enumFromInt(@as(u2, @truncate(v)));
        self.colors[1] = @enumFromInt(@as(u2, @truncate(v >> 2)));
        self.colors[2] = @enumFromInt(@as(u2, @truncate(v >> 4)));
        self.colors[3] = @enumFromInt(@as(u2, @truncate(v >> 6)));
    }

    pub fn getColor(self: *const Palette, pixel: Pixel) Color {
        return self.colors[pixel.bytes];
    }
};
