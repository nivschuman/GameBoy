const std = @import("std");
const Pixel = @import("../../../../ppu/vram/tiles/tiles.zig").Pixel;
const TileRow = @import("../../../../ppu/vram/tiles/tiles.zig").TileRow;
const Tile = @import("../../../../ppu/vram/tiles/tiles.zig").Tile;

test "get pixel" {
    const tile_row = TileRow.init(0xFF00);

    const pixel0 = tile_row.getPixel(0);
    try std.testing.expect(pixel0.bytes == 0x01);

    const pixel1 = tile_row.getPixel(0);
    try std.testing.expect(pixel1.bytes == 0x01);
}

test "get row" {
    const tile = Tile.init(0x000000C6C600C6C600FEC6C60000C67C7C);

    const row_7 = tile.getRow(7);
    try std.testing.expect(row_7.bytes == 0x0000);
}
