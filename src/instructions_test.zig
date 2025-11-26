const std = @import("std");
const Cpu = @import("cpu.zig").Cpu;
const Registers = @import("registers.zig").Registers;
const Instructions = @import("instructions.zig");

test "ADD" {
    var cpu = Cpu.init();
    cpu.registers.a = 0x10;

    Instructions.add(&cpu, &cpu.registers.a, 0x22);
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

    Instructions.adc(&cpu, &cpu.registers.a, 0x01);
    try std.testing.expect(cpu.registers.a == 0x91);
    try std.testing.expect(!cpu.registers.getSubtractionFlag());
    try std.testing.expect(!cpu.registers.getZeroFlag());
    try std.testing.expect(!cpu.registers.getCarryFlag());
    try std.testing.expect(cpu.registers.getHalfCarryFlag());
}

test "SUB" {
    var cpu = Cpu.init();

    cpu.registers.a = 0x22;
    Instructions.sub(&cpu, &cpu.registers.a, 0x11);
    try std.testing.expect(cpu.registers.a == 0x11);
    try std.testing.expect(cpu.registers.getSubtractionFlag());
    try std.testing.expect(!cpu.registers.getZeroFlag());
    try std.testing.expect(!cpu.registers.getCarryFlag());
    try std.testing.expect(!cpu.registers.getHalfCarryFlag());

    cpu.registers.a = 0x10;
    Instructions.sub(&cpu, &cpu.registers.a, 0x10);
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
    Instructions.sbc(&cpu, &cpu.registers.a, 0x05);
    try std.testing.expect(cpu.registers.a == 0x0B);
    try std.testing.expect(cpu.registers.getSubtractionFlag());
    try std.testing.expect(!cpu.registers.getZeroFlag());
    try std.testing.expect(!cpu.registers.getCarryFlag());
    try std.testing.expect(cpu.registers.getHalfCarryFlag());

    cpu.registers.a = 0x10;
    cpu.registers.f = 0x10;
    Instructions.sbc(&cpu, &cpu.registers.a, 0x05);
    try std.testing.expect(cpu.registers.a == 0x0A);
    try std.testing.expect(cpu.registers.getSubtractionFlag());
    try std.testing.expect(!cpu.registers.getZeroFlag());
    try std.testing.expect(!cpu.registers.getCarryFlag());
    try std.testing.expect(cpu.registers.getHalfCarryFlag());

    cpu.registers.a = 0x00;
    cpu.registers.f = 0x10;
    Instructions.sbc(&cpu, &cpu.registers.a, 0x01);
    try std.testing.expect(cpu.registers.a == 0xFE);
    try std.testing.expect(cpu.registers.getSubtractionFlag());
    try std.testing.expect(!cpu.registers.getZeroFlag());
    try std.testing.expect(cpu.registers.getCarryFlag());
    try std.testing.expect(cpu.registers.getHalfCarryFlag());

    cpu.registers.a = 0x00;
    cpu.registers.f = 0x10;
    Instructions.sbc(&cpu, &cpu.registers.a, 0xFF);
    try std.testing.expect(cpu.registers.a == 0x00);
    try std.testing.expect(cpu.registers.getSubtractionFlag());
    try std.testing.expect(cpu.registers.getZeroFlag());
    try std.testing.expect(cpu.registers.getCarryFlag());
    try std.testing.expect(cpu.registers.getHalfCarryFlag());
}

test "AND" {
    var cpu = Cpu.init();
    cpu.registers.a = 0xF0;

    Instructions.andFn(&cpu, &cpu.registers.a, 0x0F);
    try std.testing.expect(cpu.registers.a == 0x00);
    try std.testing.expect(!cpu.registers.getSubtractionFlag());
    try std.testing.expect(cpu.registers.getZeroFlag());
    try std.testing.expect(!cpu.registers.getCarryFlag());
    try std.testing.expect(cpu.registers.getHalfCarryFlag());
}

test "XOR" {
    var cpu = Cpu.init();
    cpu.registers.a = 0xAA;

    Instructions.xor(&cpu, &cpu.registers.a, 0xFF);
    try std.testing.expect(cpu.registers.a == 0x55);
    try std.testing.expect(!cpu.registers.getSubtractionFlag());
    try std.testing.expect(!cpu.registers.getZeroFlag());
    try std.testing.expect(!cpu.registers.getCarryFlag());
    try std.testing.expect(!cpu.registers.getHalfCarryFlag());
}

test "OR" {
    var cpu = Cpu.init();
    cpu.registers.a = 0x0A;

    Instructions.orFn(&cpu, &cpu.registers.a, 0x05);
    try std.testing.expect(cpu.registers.a == 0x0F);
    try std.testing.expect(!cpu.registers.getSubtractionFlag());
    try std.testing.expect(!cpu.registers.getZeroFlag());
    try std.testing.expect(!cpu.registers.getCarryFlag());
    try std.testing.expect(!cpu.registers.getHalfCarryFlag());
}

test "CP" {
    var cpu = Cpu.init();
    cpu.registers.a = 0x10;

    Instructions.cp(&cpu, &cpu.registers.a, 0x10);
    try std.testing.expect(cpu.registers.a == 0x10);
    try std.testing.expect(cpu.registers.getZeroFlag());
    try std.testing.expect(cpu.registers.getSubtractionFlag());
    try std.testing.expect(!cpu.registers.getCarryFlag());
    try std.testing.expect(!cpu.registers.getHalfCarryFlag());
}

test "ADD words" {
    var cpu = Cpu.init();

    cpu.registers.setHL(0x1234);
    cpu.registers.setBC(0x0001);

    var hl_val = cpu.registers.getHL();
    Instructions.addWords(&cpu, &hl_val, cpu.registers.getBC());
    cpu.registers.setHL(hl_val);

    try std.testing.expect(cpu.registers.getHL() == 0x1235);
    try std.testing.expect(!cpu.registers.getSubtractionFlag());
    try std.testing.expect(!cpu.registers.getCarryFlag());
    try std.testing.expect(!cpu.registers.getHalfCarryFlag());

    cpu.registers.setHL(0x0FFF);
    cpu.registers.setBC(0x0001);

    hl_val = cpu.registers.getHL();
    Instructions.addWords(&cpu, &hl_val, cpu.registers.getBC());
    cpu.registers.setHL(hl_val);

    try std.testing.expect(cpu.registers.getHL() == 0x1000);
    try std.testing.expect(cpu.registers.getHalfCarryFlag());
    try std.testing.expect(!cpu.registers.getCarryFlag());

    cpu.registers.setHL(0xFFFF);
    cpu.registers.setBC(0x0001);

    hl_val = cpu.registers.getHL();
    Instructions.addWords(&cpu, &hl_val, cpu.registers.getBC());
    cpu.registers.setHL(hl_val);

    try std.testing.expect(cpu.registers.getHL() == 0x0000);
    try std.testing.expect(cpu.registers.getCarryFlag());
    try std.testing.expect(cpu.registers.getHalfCarryFlag());
}

test "RLC" {
    var cpu = Cpu.init();
    cpu.registers.a = 0b10000001;

    Instructions.rlc(&cpu, &cpu.registers.a);

    try std.testing.expect(cpu.registers.a == 0b00000011);
    try std.testing.expect(cpu.registers.getCarryFlag());
    try std.testing.expect(!cpu.registers.getSubtractionFlag());
    try std.testing.expect(!cpu.registers.getHalfCarryFlag());
    try std.testing.expect(!cpu.registers.getZeroFlag());

    cpu.registers.a = 0x00;
    Instructions.rlc(&cpu, &cpu.registers.a);
    try std.testing.expect(cpu.registers.a == 0x00);
    try std.testing.expect(cpu.registers.getZeroFlag());
    try std.testing.expect(!cpu.registers.getCarryFlag());
}

test "RRC" {
    var cpu = Cpu.init();
    cpu.registers.a = 0b00101001;

    Instructions.rrc(&cpu, &cpu.registers.a);

    try std.testing.expect(cpu.registers.a == 0b10010100);
    try std.testing.expect(cpu.registers.getCarryFlag());
    try std.testing.expect(!cpu.registers.getSubtractionFlag());
    try std.testing.expect(!cpu.registers.getHalfCarryFlag());
    try std.testing.expect(!cpu.registers.getZeroFlag());

    cpu.registers.a = 0x00;
    Instructions.rrc(&cpu, &cpu.registers.a);
    try std.testing.expect(cpu.registers.a == 0x00);
    try std.testing.expect(cpu.registers.getZeroFlag());
    try std.testing.expect(!cpu.registers.getCarryFlag());
}
