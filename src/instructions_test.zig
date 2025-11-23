const std = @import("std");
const Cpu = @import("cpu.zig").Cpu;
const Registers = @import("registers.zig").Registers;
const Instructions = @import("instructions.zig");

test "ADD" {
    var cpu = Cpu.init();
    cpu.registers.a = 0x10;

    Instructions.add(&cpu, 0x22);
    try std.testing.expect(cpu.registers.a == 0x32);
    try std.testing.expect(!cpu.registers.getSubtractionFlag());
    try std.testing.expect(!cpu.registers.getZeroFlag());
    try std.testing.expect(!cpu.registers.getCarryFlag());
    try std.testing.expect(!cpu.registers.getHalfCarryFlag());
}

test "ADC" {
    var cpu = Cpu.init();
    cpu.registers.a = 0x8F;
    cpu.registers.f = 0x10;

    Instructions.adc(&cpu, 0x01);
    try std.testing.expect(cpu.registers.a == 0x91);
    try std.testing.expect(!cpu.registers.getSubtractionFlag());
    try std.testing.expect(!cpu.registers.getZeroFlag());
    try std.testing.expect(!cpu.registers.getCarryFlag());
    try std.testing.expect(cpu.registers.getHalfCarryFlag());
}

test "SUB" {
    var cpu = Cpu.init();

    cpu.registers.a = 0x22;
    Instructions.sub(&cpu, 0x11);
    try std.testing.expect(cpu.registers.a == 0x11);
    try std.testing.expect(cpu.registers.getSubtractionFlag());
    try std.testing.expect(!cpu.registers.getZeroFlag());
    try std.testing.expect(!cpu.registers.getCarryFlag());
    try std.testing.expect(!cpu.registers.getHalfCarryFlag());

    cpu.registers.a = 0x10;
    Instructions.sub(&cpu, 0x10);
    try std.testing.expect(cpu.registers.a == 0x00);
    try std.testing.expect(cpu.registers.getZeroFlag());
    try std.testing.expect(cpu.registers.getSubtractionFlag());
    try std.testing.expect(!cpu.registers.getCarryFlag());
    try std.testing.expect(!cpu.registers.getHalfCarryFlag());
}

test "SBC" {
    var cpu = Cpu.init();

    cpu.registers.a = 0x10;
    cpu.registers.f = 0x00;
    Instructions.sbc(&cpu, 0x05);
    try std.testing.expect(cpu.registers.a == 0x0B);
    try std.testing.expect(cpu.registers.getSubtractionFlag());
    try std.testing.expect(!cpu.registers.getZeroFlag());
    try std.testing.expect(!cpu.registers.getCarryFlag());
    try std.testing.expect(cpu.registers.getHalfCarryFlag());

    cpu.registers.a = 0x10;
    cpu.registers.f = 0x10;
    Instructions.sbc(&cpu, 0x05);
    try std.testing.expect(cpu.registers.a == 0x0A);
    try std.testing.expect(cpu.registers.getSubtractionFlag());
    try std.testing.expect(!cpu.registers.getZeroFlag());
    try std.testing.expect(!cpu.registers.getCarryFlag());
    try std.testing.expect(cpu.registers.getHalfCarryFlag());

    cpu.registers.a = 0x00;
    cpu.registers.f = 0x10;
    Instructions.sbc(&cpu, 0x01);
    try std.testing.expect(cpu.registers.a == 0xFE);
    try std.testing.expect(cpu.registers.getSubtractionFlag());
    try std.testing.expect(!cpu.registers.getZeroFlag());
    try std.testing.expect(cpu.registers.getCarryFlag());
    try std.testing.expect(cpu.registers.getHalfCarryFlag());

    cpu.registers.a = 0x00;
    cpu.registers.f = 0x10;
    Instructions.sbc(&cpu, 0xFF);
    try std.testing.expect(cpu.registers.a == 0x00);
    try std.testing.expect(cpu.registers.getSubtractionFlag());
    try std.testing.expect(cpu.registers.getZeroFlag());
    try std.testing.expect(cpu.registers.getCarryFlag());
    try std.testing.expect(cpu.registers.getHalfCarryFlag());
}
