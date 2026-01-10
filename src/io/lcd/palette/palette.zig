pub const Color = enum(u2) {
    White = 0,
    LightGray = 1,
    DarkGray = 2,
    Black = 3,

    pub fn getUiColor(self: Color) u32 {
        return switch (self) {
            .White => 0xFF000000,
            .LightGray => 0xFF555555,
            .DarkGray => 0xFFAAAAAA,
            .Black => 0xFFFFFFFF,
        };
    }
};

pub const Palette = struct {
    colors: [4]Color,

    pub fn init(value: u8) Palette {
        var palette: Palette = .{
            .colors = [_]Color{ Color.Black, Color.DarkGray, Color.LightGray, Color.White },
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
        self.colors[0] = @enumFromInt(@as(u2, @truncate(value)));
        self.colors[1] = @enumFromInt(@as(u2, @truncate(value >> 2)));
        self.colors[2] = @enumFromInt(@as(u2, @truncate(value >> 4)));
        self.colors[3] = @enumFromInt(@as(u2, @truncate(value >> 6)));
    }
};

pub const BackgroundPalette = struct {
    palette: Palette,

    pub fn init(value: u8) BackgroundPalette {
        return .{ .palette = Palette.init(value) };
    }

    pub fn getValue(self: *const BackgroundPalette) u8 {
        return self.palette.getValue();
    }

    pub fn setValue(self: *BackgroundPalette, value: u8) void {
        self.palette.setValue(value);
    }
};

pub const ObjectPalette = struct {
    palette: Palette,

    pub fn init(value: u8) ObjectPalette {
        return .{ .palette = Palette.init(value) };
    }

    pub fn getValue(self: *const ObjectPalette) u8 {
        return self.palette.getValue();
    }

    pub fn setValue(self: *ObjectPalette, value: u8) void {
        self.palette.setValue(value & 0xFC);
    }
};
