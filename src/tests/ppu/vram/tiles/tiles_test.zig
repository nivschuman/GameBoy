const std = @import("std");
const Pixel = @import("../../../../ppu/vram/tiles/tiles.zig").Pixel;
const TileRow = @import("../../../../ppu/vram/tiles/tiles.zig").TileRow;
const Tile = @import("../../../../ppu/vram/tiles/tiles.zig").Tile;
const TileData = @import("../../../../ppu/vram/tiles/tiles.zig").TileData;

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

test "get tile address" {
    try std.testing.expect(TileData.TILE_DATA_1.getTileAddress(0) == 0x8000);
    try std.testing.expect(TileData.TILE_DATA_1.getTileAddress(1) == 0x8010);

    try std.testing.expect(TileData.TILE_DATA_2.getTileAddress(0) == 0x9000);
    try std.testing.expect(TileData.TILE_DATA_2.getTileAddress(0xFF) == 0x8FF0);
}
