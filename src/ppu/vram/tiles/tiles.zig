pub const Pixel = struct {
    bytes: u2,

    pub fn init(bytes: u2) Pixel {
        return .{ .bytes = bytes };
    }
};

pub const TileRow = struct {
    bytes: u16,

    pub fn init(bytes: u16) TileRow {
        return .{ .bytes = bytes };
    }

    pub fn getPixel(self: *const TileRow, position: u3) Pixel {
        const high_byte: u8 = @truncate(self.bytes >> 8);
        const low_byte: u8 = @truncate(self.bytes);

        const pos = 7 - position;
        const high_pixel: u1 = @truncate(high_byte >> pos);
        const low_pixel: u1 = @truncate(low_byte >> pos);
        return Pixel.init((@as(u2, low_pixel) << 1) | @as(u2, high_pixel));
    }

    pub fn getPixels(self: *const TileRow) [8]Pixel {
        var pixels: [8]Pixel = undefined;
        var position: usize = 0;
        while (position < 8) : (position += 1) {
            pixels[position] = self.getPixel(@truncate(position));
        }

        return pixels;
    }
};

pub const Tile = struct {
    pub const SIZE = 16; //16 bytes

    bytes: u128,

    pub fn init(bytes: u128) Tile {
        return .{ .bytes = bytes };
    }

    pub fn getRow(self: *const Tile, position: u3) TileRow {
        const low_byte: u8 = @truncate(self.bytes >> (16 * @as(u7, position)));
        const high_byte: u8 = @truncate(self.bytes >> (16 * @as(u7, position) + 8));
        return TileRow.init((@as(u16, high_byte) << 8) | @as(u16, low_byte));
    }

    pub fn getRows(self: *const Tile) [8]TileRow {
        var rows: [8]TileRow = undefined;
        var position: usize = 0;
        while (position < 8) : (position += 1) {
            rows[position] = self.getRow(@truncate(position));
        }

        return rows;
    }
};
