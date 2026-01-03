pub const Sprite = struct {
    const SIZE = 4;

    y: u8,
    x: u8,
    tile_index: u8,
    attributes: u8,

    pub fn init() Sprite {
        return .{
            .y = 0,
            .x = 0,
            .tile_index = 0,
            .attributes = 0,
        };
    }

    pub fn getPriority(self: *const Sprite) u1 {
        return @truncate(self.attributes >> 7);
    }

    pub fn getYFlip(self: *const Sprite) u1 {
        return @truncate(self.attributes >> 6);
    }

    pub fn getXFlip(self: *const Sprite) u1 {
        return @truncate(self.attributes >> 5);
    }

    pub fn getDmgPalette(self: *const Sprite) u1 {
        return @truncate(self.attributes >> 4);
    }

    pub fn getVramBank(self: *const Sprite) u1 {
        return @truncate(self.attributes >> 3);
    }

    pub fn getCgbPalette(self: *const Sprite) u3 {
        return @truncate(self.attributes);
    }

    pub fn setPriority(self: *Sprite, value: u1) void {
        if (value == 1) {
            self.attributes |= 0x80;
        } else {
            self.attributes &= ~0x80;
        }
    }

    pub fn setYFlip(self: *Sprite, value: u1) void {
        if (value == 1) {
            self.attributes |= 0x40;
        } else {
            self.attributes &= ~0x40;
        }
    }

    pub fn setXFlip(self: *Sprite, value: u1) void {
        if (value == 1) {
            self.attributes |= 0x20;
        } else {
            self.attributes &= ~0x20;
        }
    }

    pub fn setDmgPalette(self: *Sprite, value: u1) void {
        if (value == 1) {
            self.attributes |= 0x10;
        } else {
            self.attributes &= ~0x10;
        }
    }

    pub fn setVramBank(self: *Sprite, value: u1) void {
        if (value == 1) {
            self.attributes |= 0x08;
        } else {
            self.attributes &= ~0x08;
        }
    }

    pub fn setCgbPalette(self: *Sprite, value: u3) void {
        self.attributes = (self.attributes & ~0x07) | @as(u8, value);
    }
};

pub const Oam = struct {
    const SIZE = 40;

    sprites: [40]Sprite,

    pub fn init() Oam {
        return .{ .sprites = [_]Sprite{Sprite.init()} ** SIZE };
    }

    pub fn readByte(self: *const Oam, address: u16) u8 {
        const sprite = &self.sprites[address / Sprite.SIZE];
        const offset = address % Sprite.SIZE;
        return switch (offset) {
            0 => sprite.y,
            1 => sprite.x,
            2 => sprite.tile_index,
            3 => sprite.attributes,
            else => @panic("invalid sprite offset"),
        };
    }

    pub fn writeByte(self: *Oam, address: u16, value: u8) void {
        const sprite = &self.sprites[address / Sprite.SIZE];
        const offset = address % Sprite.SIZE;
        return switch (offset) {
            0 => sprite.y = value,
            1 => sprite.x = value,
            2 => sprite.tile_index = value,
            3 => sprite.attributes = value,
            else => @panic("invalid sprite offset"),
        };
    }
};
