const std = @import("std");
const Registers = @import("../../../src/cpu/registers/registers.zig").Registers;

test "16-bit registers get/set" {
    var r = Registers.init();

    r.setBC(0x1234);
    try std.testing.expect(r.getBC() == 0x1234);
    try std.testing.expect(r.b == 0x12);
    try std.testing.expect(r.c == 0x34);

    r.setDE(0xABCD);
    try std.testing.expect(r.getDE() == 0xABCD);
    try std.testing.expect(r.d == 0xAB);
    try std.testing.expect(r.e == 0xCD);

    r.setHL(0xFACE);
    try std.testing.expect(r.getHL() == 0xFACE);
    try std.testing.expect(r.h == 0xFA);
    try std.testing.expect(r.l == 0xCE);
}

test "flags get/set" {
    var r = Registers.init();

    r.setZeroFlag(true);
    try std.testing.expect(r.getZeroFlag());
    r.setZeroFlag(false);
    try std.testing.expect(!r.getZeroFlag());

    r.setSubtractionFlag(true);
    try std.testing.expect(r.getSubtractionFlag());
    r.setSubtractionFlag(false);
    try std.testing.expect(!r.getSubtractionFlag());

    r.setHalfCarryFlag(true);
    try std.testing.expect(r.getHalfCarryFlag());
    r.setHalfCarryFlag(false);
    try std.testing.expect(!r.getHalfCarryFlag());

    r.setCarryFlag(true);
    try std.testing.expect(r.getCarryFlag());
    r.setCarryFlag(false);
    try std.testing.expect(!r.getCarryFlag());
}
