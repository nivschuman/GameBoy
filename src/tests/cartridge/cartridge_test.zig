const std = @import("std");
const cartridge = @import("../../cartridge/cartridge.zig");
const files = @import("../../utils/files/files.zig");

test "load cartridge" {
    const allocator = std.testing.allocator;
    const file_loader = files.FileLoader.init(allocator);
    const rom_file_bytes = try file_loader.loadFile("./src/tests/roms/dmg-acid2.gb");
    defer rom_file_bytes.deinit();

    const cart = cartridge.Cartridge.init(rom_file_bytes.bytes);

    const expected_title = "DMG-ACID2";
    const title_slice = cart.header.title();
    try std.testing.expectEqualSlices(u8, title_slice[0..expected_title.len], expected_title);

    try std.testing.expect(cart.header.newLicensee() == .None);
    try std.testing.expect(cart.header.cartridgeType() == .ROM_ONLY);
    try std.testing.expect(cart.header.romSize() == .KB_32);
    try std.testing.expect(cart.header.ramSize() == .NONE);
    try std.testing.expect(cart.header.versionNumber() == 0x00);
    try std.testing.expect(cart.validHeaderChecksum());
}
