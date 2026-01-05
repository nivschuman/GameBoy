const Tile = @import("tiles/tiles.zig").Tile;

pub const VRam = struct {
    pub const TILES_SIZE = 0x1800;
    pub const TILES_COUNT = TILES_SIZE / 16;
    pub const TILE_MAPS_SIZE = 0x800;

    tile_data: [TILES_SIZE]u8,
    tile_maps: [TILE_MAPS_SIZE]u8,

    pub fn init() VRam {
        return .{
            .tile_data = [_]u8{0} ** TILES_SIZE,
            .tile_maps = [_]u8{0} ** TILE_MAPS_SIZE,
        };
    }

    pub fn readByte(self: *const VRam, address: u16) u8 {
        return switch (address) {
            0x8000...0x97FF => self.tile_data[address - 0x8000],
            0x9800...0x9FFF => self.tile_maps[address - 0x9800],
            else => @panic("invalid vram address"),
        };
    }

    pub fn writeByte(self: *VRam, address: u16, value: u8) void {
        switch (address) {
            0x8000...0x97FF => self.tile_data[address - 0x8000] = value,
            0x9800...0x9FFF => self.tile_maps[address - 0x9800] = value,
            else => @panic("invalid vram address"),
        }
    }

    pub fn getTile(self: *const VRam, position: u16) Tile {
        const tile_start: usize = position * 16;
        var bytes: u128 = 0;
        var row: usize = 0;
        while (row < 8) : (row += 1) {
            const low_byte: u8 = self.tile_data[tile_start + row * 2];
            const high_byte: u8 = self.tile_data[tile_start + row * 2];
            const bit_offset: u7 = @truncate(row * 16);
            bytes |= @as(u128, low_byte) << bit_offset;
            bytes |= @as(u128, high_byte) << (bit_offset + 8);
        }

        return Tile.init(bytes);
    }

    pub fn getTiles(self: *const VRam) [TILES_COUNT]Tile {
        var tiles: [TILES_COUNT]Tile = undefined;
        var tile_number: u16 = 0;
        while (tile_number < TILES_COUNT) : (tile_number += 1) {
            tiles[tile_number] = self.getTile(tile_number);
        }

        return tiles;
    }
};
