const Tile = @import("tiles/tiles.zig").Tile;

pub const VRam = struct {
    const SIZE = 0x2000;

    bytes: [SIZE]u8,

    pub fn init() VRam {
        return .{ .bytes = [_]u8{0} ** SIZE };
    }

    pub fn readByte(self: *const VRam, address: u16) u8 {
        return self.bytes[address];
    }

    pub fn writeByte(self: *VRam, address: u16, value: u8) void {
        self.bytes[address] = value;
    }

    pub fn getTile(self: *const VRam, baseAddress: u16, tileIndex: u8) Tile {
        const tileStart: u16 = baseAddress + (@as(u16, tileIndex) * 16);
        var bytes: u128 = 0;
        var row: u3 = 0;
        while (row < 8) : (row += 1) {
            const low_byte: u8 = self.readByte(tileStart + @as(u16, row * 2));
            const high_byte: u8 = self.readByte(tileStart + @as(u16, row * 2 + 1));
            const bit_offset: u7 = @as(u7, row) * 16;
            bytes |= @as(u128, low_byte) << bit_offset;
            bytes |= @as(u128, high_byte) << (bit_offset + 8);
        }

        return Tile.init(bytes);
    }
};
