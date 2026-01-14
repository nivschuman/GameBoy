const Dma = @import("dma/dma.zig").Dma;
const ObjectSize = @import("types/types.zig").ObjectSize;
const LcdMode = @import("types/types.zig").LcdMode;
const StatInterruptCondition = @import("types/types.zig").StatInterruptCondition;
const BackgroundPalette = @import("palette/palette.zig").BackgroundPalette;
const ObjectPalette = @import("palette/palette.zig").ObjectPalette;

pub const Lcd = struct {
    lcdc: u8, //lcd control
    ly: u8, //lcd y coordinate
    lyc: u8, //lcd y coordinate compare
    stat: u8, //lcd status
    scy: u8, //scroll y
    scx: u8, //scroll x
    wy: u8, //window y
    wx: u8, //window x
    bgp: BackgroundPalette, //background pallete
    obp0: ObjectPalette, //object background palette 0
    obp1: ObjectPalette, //object background palette 1
    dma: *Dma,

    pub fn init(dma: *Dma) Lcd {
        return .{
            .lcdc = 0x91,
            .ly = 0,
            .lyc = 0,
            .stat = 0,
            .scy = 0,
            .scx = 0,
            .wy = 0,
            .wx = 0,
            .bgp = BackgroundPalette.init(0xFC),
            .obp0 = ObjectPalette.init(0xFF),
            .obp1 = ObjectPalette.init(0xFF),
            .dma = dma,
        };
    }

    pub fn readByte(self: *const Lcd, address: u16) u8 {
        return switch (address) {
            0xFF40 => self.lcdc,
            0xFF41 => self.stat,
            0xFF42 => self.scy,
            0xFF43 => self.scx,
            0xFF44 => self.ly,
            0xFF45 => self.lyc,
            0xFF47 => self.bgp.getValue(),
            0xFF48 => self.obp0.getValue(),
            0xFF49 => self.obp1.getValue(),
            0xFF4A => self.wy,
            0xFF4B => self.wx,
            else => @panic("invalid lcd address"),
        };
    }

    pub fn writeByte(self: *Lcd, address: u16, value: u8) void {
        switch (address) {
            0xFF40 => self.lcdc = value,
            0xFF41 => self.setStat(value),
            0xFF42 => self.scy = value,
            0xFF43 => self.scx = value,
            0xFF45 => self.lyc = value,
            0xFF46 => self.dma.activate(value),
            0xFF47 => self.bgp.setValue(value),
            0xFF48 => self.obp0.setValue(value),
            0xFF49 => self.obp1.setValue(value),
            0xFF4A => self.wy = value,
            0xFF4B => self.wx = value,
            else => @panic("invalid lcd address"),
        }
    }

    pub fn setStat(self: *Lcd, value: u8) void {
        self.stat = (self.stat & 0x03) | (value & 0xFC);
    }

    pub fn getLcdMode(self: *const Lcd) LcdMode {
        return @enumFromInt(@as(u2, @truncate(self.stat)));
    }

    pub fn setLcdMode(self: *Lcd, value: LcdMode) void {
        self.stat = (self.stat & 0xFC) | @as(u8, @intFromEnum(value));
    }

    pub fn getLycEqualsLy(self: *const Lcd) u1 {
        return @truncate(self.stat >> 2);
    }

    pub fn setLycEqualsLy(self: *Lcd, value: bool) void {
        if (!value) {
            self.stat &= 0xFB;
        } else {
            self.stat |= 0x04;
        }
    }

    pub fn getStatInterruptCondition(self: *const Lcd, condition: StatInterruptCondition) bool {
        return @as(u1, @truncate(self.stat >> @intFromEnum(condition))) == 1;
    }

    pub fn setStatInterruptCondition(self: *Lcd, condition: StatInterruptCondition, value: bool) void {
        if (!value) {
            self.stat &= ~(@as(u8, 1) << @as(u3, @intFromEnum(condition)));
        } else {
            self.stat |= (@as(u8, 1) << @as(u3, @intFromEnum(condition)));
        }
    }

    pub fn getLcdEnable(self: *const Lcd) u1 {
        return @truncate(self.lcdc >> 7);
    }

    pub fn getWindowMapArea(self: *const Lcd) u16 {
        const bit: u1 = @truncate(self.lcdc >> 6);
        return if (bit == 0) 0x9800 else 0x9C00;
    }

    pub fn getWindowEnable(self: *const Lcd) u1 {
        return @truncate(self.lcdc >> 5);
    }

    pub fn getBackgroundWindowDataArea(self: *const Lcd) u16 {
        const bit: u1 = @truncate(self.lcdc >> 4);
        return if (bit == 0) 0x8800 else 0x8000;
    }

    pub fn getBackgroundMapArea(self: *const Lcd) u16 {
        const bit: u1 = @truncate(self.lcdc >> 3);
        return if (bit == 0) 0x9800 else 0x9C00;
    }

    pub fn getObjectSize(self: *const Lcd) ObjectSize {
        const bit: u1 = @truncate(self.lcdc >> 2);
        if (bit == 0) {
            return .{
                .width = 8,
                .height = 8,
            };
        }

        return .{
            .width = 8,
            .height = 16,
        };
    }

    pub fn getObjectEnable(self: *const Lcd) u1 {
        return @truncate(self.lcdc >> 1);
    }

    pub fn getBackgroundWindowEnable(self: *const Lcd) u1 {
        return @truncate(self.lcdc);
    }
};
