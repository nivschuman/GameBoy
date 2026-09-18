const Dma = @import("dma/dma.zig").Dma;
const ObjectSize = @import("types/types.zig").ObjectSize;
const LcdMode = @import("types/types.zig").LcdMode;
const StatInterruptCondition = @import("types/types.zig").StatInterruptCondition;
const Palette = @import("palette/palette.zig").Palette;
const TileMap = @import("../../ppu/vram/tiles/tiles.zig").TileMap;
const TileData = @import("../../ppu/vram/tiles/tiles.zig").TileData;

pub const Lcd = struct {
    lcdc: u8, //lcd control
    ly: u8, //lcd y coordinate
    lyc: u8, //lcd y coordinate compare
    stat: u8, //lcd status
    scy: u8, //scroll y
    scx: u8, //scroll x
    wy: u8, //window y
    wx: u8, //window x
    bgp: Palette, //background pallete
    obp0: Palette, //object background palette 0
    obp1: Palette, //object background palette 1
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
            .bgp = Palette.init(0xFC, .BACKGROUND),
            .obp0 = Palette.init(0xFF, .OBJECT),
            .obp1 = Palette.init(0xFF, .OBJECT),
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

    pub fn getWindowTileMap(self: *const Lcd) TileMap {
        const bit: u1 = @truncate(self.lcdc >> 6);
        return if (bit == 0) .TILE_MAP_1 else .TILE_MAP_2;
    }

    pub fn getWindowEnable(self: *const Lcd) u1 {
        return @truncate(self.lcdc >> 5);
    }

    pub fn getTileData(self: *const Lcd) TileData {
        const bit: u1 = @truncate(self.lcdc >> 4);
        return if (bit == 0) .TILE_DATA_2 else .TILE_DATA_1;
    }

    pub fn getBackgroundTileMap(self: *const Lcd) TileMap {
        const bit: u1 = @truncate(self.lcdc >> 3);
        return if (bit == 0) .TILE_MAP_1 else .TILE_MAP_2;
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

    pub fn getBackgroundAndWindowPriority(self: *const Lcd) u1 {
        return @truncate(self.lcdc);
    }
};
