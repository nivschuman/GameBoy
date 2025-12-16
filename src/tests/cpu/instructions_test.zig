const std = @import("std");
const Cpu = @import("../../cpu/cpu.zig").Cpu;
const Mmu = @import("../../mmu/mmu.zig").Mmu;
const Cartridge = @import("../../cartridge/cartridge.zig").Cartridge;
const instructions = @import("../../cpu/instructions.zig");
const CycleManager = @import("../../cycles/cycles.zig").CycleManager;

test "add" {
    var rom: [0x8000]u8 = [_]u8{0} ** 0x8000;
    var cart = Cartridge.init(rom[0..]);
    var mmu = Mmu.init(&cart);
    var cycle_manager = CycleManager.init();
    var cpu = Cpu.init(&mmu, &cycle_manager);
    cpu.registers.a = 0x10;

    instructions.add(&cpu, &cpu.registers.a, 0x22);
    try std.testing.expect(cpu.registers.a == 0x32);
    try std.testing.expect(!cpu.registers.getSubtractionFlag());
    try std.testing.expect(!cpu.registers.getZeroFlag());
    try std.testing.expect(!cpu.registers.getCarryFlag());
    try std.testing.expect(!cpu.registers.getHalfCarryFlag());
}

test "adc" {
    var rom: [0x8000]u8 = [_]u8{0} ** 0x8000;
    var cart = Cartridge.init(rom[0..]);
    var mmu = Mmu.init(&cart);
    var cycle_manager = CycleManager.init();
    var cpu = Cpu.init(&mmu, &cycle_manager);
    cpu.registers.a = 0x8F;
    cpu.registers.f = 0x10;

    instructions.adc(&cpu, &cpu.registers.a, 0x01);
    try std.testing.expect(cpu.registers.a == 0x91);
    try std.testing.expect(!cpu.registers.getSubtractionFlag());
    try std.testing.expect(!cpu.registers.getZeroFlag());
    try std.testing.expect(!cpu.registers.getCarryFlag());
    try std.testing.expect(cpu.registers.getHalfCarryFlag());
}

test "sub" {
    var rom: [0x8000]u8 = [_]u8{0} ** 0x8000;
    var cart = Cartridge.init(rom[0..]);
    var mmu = Mmu.init(&cart);
    var cycle_manager = CycleManager.init();
    var cpu = Cpu.init(&mmu, &cycle_manager);

    cpu.registers.a = 0x22;
    instructions.sub(&cpu, &cpu.registers.a, 0x11);
    try std.testing.expect(cpu.registers.a == 0x11);
    try std.testing.expect(cpu.registers.getSubtractionFlag());
    try std.testing.expect(!cpu.registers.getZeroFlag());
    try std.testing.expect(!cpu.registers.getCarryFlag());
    try std.testing.expect(!cpu.registers.getHalfCarryFlag());

    cpu.registers.a = 0x10;
    instructions.sub(&cpu, &cpu.registers.a, 0x10);
    try std.testing.expect(cpu.registers.a == 0x00);
    try std.testing.expect(cpu.registers.getZeroFlag());
    try std.testing.expect(cpu.registers.getSubtractionFlag());
    try std.testing.expect(!cpu.registers.getCarryFlag());
    try std.testing.expect(!cpu.registers.getHalfCarryFlag());
}

test "sbc" {
    var rom: [0x8000]u8 = [_]u8{0} ** 0x8000;
    var cart = Cartridge.init(rom[0..]);
    var mmu = Mmu.init(&cart);
    var cycle_manager = CycleManager.init();
    var cpu = Cpu.init(&mmu, &cycle_manager);

    cpu.registers.a = 0x10;
    cpu.registers.f = 0x00;
    instructions.sbc(&cpu, &cpu.registers.a, 0x05);
    try std.testing.expect(cpu.registers.a == 0x0B);
    try std.testing.expect(cpu.registers.getSubtractionFlag());
    try std.testing.expect(!cpu.registers.getZeroFlag());
    try std.testing.expect(!cpu.registers.getCarryFlag());
    try std.testing.expect(cpu.registers.getHalfCarryFlag());

    cpu.registers.a = 0x10;
    cpu.registers.f = 0x10;
    instructions.sbc(&cpu, &cpu.registers.a, 0x05);
    try std.testing.expect(cpu.registers.a == 0x0A);
    try std.testing.expect(cpu.registers.getSubtractionFlag());
    try std.testing.expect(!cpu.registers.getZeroFlag());
    try std.testing.expect(!cpu.registers.getCarryFlag());
    try std.testing.expect(cpu.registers.getHalfCarryFlag());

    cpu.registers.a = 0x00;
    cpu.registers.f = 0x10;
    instructions.sbc(&cpu, &cpu.registers.a, 0x01);
    try std.testing.expect(cpu.registers.a == 0xFE);
    try std.testing.expect(cpu.registers.getSubtractionFlag());
    try std.testing.expect(!cpu.registers.getZeroFlag());
    try std.testing.expect(cpu.registers.getCarryFlag());
    try std.testing.expect(cpu.registers.getHalfCarryFlag());

    cpu.registers.a = 0x00;
    cpu.registers.f = 0x10;
    instructions.sbc(&cpu, &cpu.registers.a, 0xFF);
    try std.testing.expect(cpu.registers.a == 0x00);
    try std.testing.expect(cpu.registers.getSubtractionFlag());
    try std.testing.expect(cpu.registers.getZeroFlag());
    try std.testing.expect(cpu.registers.getCarryFlag());
    try std.testing.expect(cpu.registers.getHalfCarryFlag());
}

test "and" {
    var rom: [0x8000]u8 = [_]u8{0} ** 0x8000;
    var cart = Cartridge.init(rom[0..]);
    var mmu = Mmu.init(&cart);
    var cycle_manager = CycleManager.init();
    var cpu = Cpu.init(&mmu, &cycle_manager);
    cpu.registers.a = 0xF0;

    instructions.andFn(&cpu, &cpu.registers.a, 0x0F);
    try std.testing.expect(cpu.registers.a == 0x00);
    try std.testing.expect(!cpu.registers.getSubtractionFlag());
    try std.testing.expect(cpu.registers.getZeroFlag());
    try std.testing.expect(!cpu.registers.getCarryFlag());
    try std.testing.expect(cpu.registers.getHalfCarryFlag());
}

test "xor" {
    var rom: [0x8000]u8 = [_]u8{0} ** 0x8000;
    var cart = Cartridge.init(rom[0..]);
    var mmu = Mmu.init(&cart);
    var cycle_manager = CycleManager.init();
    var cpu = Cpu.init(&mmu, &cycle_manager);
    cpu.registers.a = 0xAA;

    instructions.xor(&cpu, &cpu.registers.a, 0xFF);
    try std.testing.expect(cpu.registers.a == 0x55);
    try std.testing.expect(!cpu.registers.getSubtractionFlag());
    try std.testing.expect(!cpu.registers.getZeroFlag());
    try std.testing.expect(!cpu.registers.getCarryFlag());
    try std.testing.expect(!cpu.registers.getHalfCarryFlag());
}

test "or" {
    var rom: [0x8000]u8 = [_]u8{0} ** 0x8000;
    var cart = Cartridge.init(rom[0..]);
    var mmu = Mmu.init(&cart);
    var cycle_manager = CycleManager.init();
    var cpu = Cpu.init(&mmu, &cycle_manager);
    cpu.registers.a = 0x0A;

    instructions.orFn(&cpu, &cpu.registers.a, 0x05);
    try std.testing.expect(cpu.registers.a == 0x0F);
    try std.testing.expect(!cpu.registers.getSubtractionFlag());
    try std.testing.expect(!cpu.registers.getZeroFlag());
    try std.testing.expect(!cpu.registers.getCarryFlag());
    try std.testing.expect(!cpu.registers.getHalfCarryFlag());
}

test "cp" {
    var rom: [0x8000]u8 = [_]u8{0} ** 0x8000;
    var cart = Cartridge.init(rom[0..]);
    var mmu = Mmu.init(&cart);
    var cycle_manager = CycleManager.init();
    var cpu = Cpu.init(&mmu, &cycle_manager);
    cpu.registers.a = 0x10;

    instructions.cp(&cpu, &cpu.registers.a, 0x10);
    try std.testing.expect(cpu.registers.a == 0x10);
    try std.testing.expect(cpu.registers.getZeroFlag());
    try std.testing.expect(cpu.registers.getSubtractionFlag());
    try std.testing.expect(!cpu.registers.getCarryFlag());
    try std.testing.expect(!cpu.registers.getHalfCarryFlag());
}

test "addWords" {
    var rom: [0x8000]u8 = [_]u8{0} ** 0x8000;
    var cart = Cartridge.init(rom[0..]);
    var mmu = Mmu.init(&cart);
    var cycle_manager = CycleManager.init();
    var cpu = Cpu.init(&mmu, &cycle_manager);

    cpu.registers.setHL(0x1234);
    cpu.registers.setBC(0x0001);

    var hl_val = cpu.registers.getHL();
    instructions.addWords(&cpu, &hl_val, cpu.registers.getBC());
    cpu.registers.setHL(hl_val);

    try std.testing.expect(cpu.registers.getHL() == 0x1235);
    try std.testing.expect(!cpu.registers.getSubtractionFlag());
    try std.testing.expect(!cpu.registers.getCarryFlag());
    try std.testing.expect(!cpu.registers.getHalfCarryFlag());

    cpu.registers.setHL(0x0FFF);
    cpu.registers.setBC(0x0001);

    hl_val = cpu.registers.getHL();
    instructions.addWords(&cpu, &hl_val, cpu.registers.getBC());
    cpu.registers.setHL(hl_val);

    try std.testing.expect(cpu.registers.getHL() == 0x1000);
    try std.testing.expect(cpu.registers.getHalfCarryFlag());
    try std.testing.expect(!cpu.registers.getCarryFlag());

    cpu.registers.setHL(0xFFFF);
    cpu.registers.setBC(0x0001);

    hl_val = cpu.registers.getHL();
    instructions.addWords(&cpu, &hl_val, cpu.registers.getBC());
    cpu.registers.setHL(hl_val);

    try std.testing.expect(cpu.registers.getHL() == 0x0000);
    try std.testing.expect(cpu.registers.getCarryFlag());
    try std.testing.expect(cpu.registers.getHalfCarryFlag());
}

test "rlc" {
    var rom: [0x8000]u8 = [_]u8{0} ** 0x8000;
    var cart = Cartridge.init(rom[0..]);
    var mmu = Mmu.init(&cart);
    var cycle_manager = CycleManager.init();
    var cpu = Cpu.init(&mmu, &cycle_manager);
    cpu.registers.a = 0b10000001;

    instructions.rlc(&cpu, &cpu.registers.a);

    try std.testing.expect(cpu.registers.a == 0b00000011);
    try std.testing.expect(cpu.registers.getCarryFlag());
    try std.testing.expect(!cpu.registers.getSubtractionFlag());
    try std.testing.expect(!cpu.registers.getHalfCarryFlag());
    try std.testing.expect(!cpu.registers.getZeroFlag());

    cpu.registers.a = 0x00;
    instructions.rlc(&cpu, &cpu.registers.a);
    try std.testing.expect(cpu.registers.a == 0x00);
    try std.testing.expect(cpu.registers.getZeroFlag());
    try std.testing.expect(!cpu.registers.getCarryFlag());
}

test "rrc" {
    var rom: [0x8000]u8 = [_]u8{0} ** 0x8000;
    var cart = Cartridge.init(rom[0..]);
    var mmu = Mmu.init(&cart);
    var cycle_manager = CycleManager.init();
    var cpu = Cpu.init(&mmu, &cycle_manager);
    cpu.registers.a = 0b00101001;

    instructions.rrc(&cpu, &cpu.registers.a);

    try std.testing.expect(cpu.registers.a == 0b10010100);
    try std.testing.expect(cpu.registers.getCarryFlag());
    try std.testing.expect(!cpu.registers.getSubtractionFlag());
    try std.testing.expect(!cpu.registers.getHalfCarryFlag());
    try std.testing.expect(!cpu.registers.getZeroFlag());

    cpu.registers.a = 0x00;
    instructions.rrc(&cpu, &cpu.registers.a);
    try std.testing.expect(cpu.registers.a == 0x00);
    try std.testing.expect(cpu.registers.getZeroFlag());
    try std.testing.expect(!cpu.registers.getCarryFlag());
}

test "rl" {
    var rom: [0x8000]u8 = [_]u8{0} ** 0x8000;
    var cart = Cartridge.init(rom[0..]);
    var mmu = Mmu.init(&cart);
    var cycle_manager = CycleManager.init();
    var cpu = Cpu.init(&mmu, &cycle_manager);
    cpu.registers.a = 0b10000000;
    instructions.rl(&cpu, &cpu.registers.a);
    try std.testing.expect(cpu.registers.a == 0);
    try std.testing.expect(cpu.registers.getCarryFlag());
}

test "rr" {
    var rom: [0x8000]u8 = [_]u8{0} ** 0x8000;
    var cart = Cartridge.init(rom[0..]);
    var mmu = Mmu.init(&cart);
    var cycle_manager = CycleManager.init();
    var cpu = Cpu.init(&mmu, &cycle_manager);
    cpu.registers.a = 0b00000001;
    instructions.rr(&cpu, &cpu.registers.a);
    try std.testing.expect(cpu.registers.a == 0);
    try std.testing.expect(cpu.registers.getCarryFlag());
}

test "cpl" {
    var rom: [0x8000]u8 = [_]u8{0} ** 0x8000;
    var cart = Cartridge.init(rom[0..]);
    var mmu = Mmu.init(&cart);
    var cycle_manager = CycleManager.init();
    var cpu = Cpu.init(&mmu, &cycle_manager);
    cpu.registers.a = 0xAA;
    instructions.cpl(&cpu, &cpu.registers.a);
    try std.testing.expect(cpu.registers.a == 0x55);
    try std.testing.expect(cpu.registers.getSubtractionFlag());
    try std.testing.expect(cpu.registers.getHalfCarryFlag());
}

test "scf" {
    var rom: [0x8000]u8 = [_]u8{0} ** 0x8000;
    var cart = Cartridge.init(rom[0..]);
    var mmu = Mmu.init(&cart);
    var cycle_manager = CycleManager.init();
    var cpu = Cpu.init(&mmu, &cycle_manager);
    instructions.scf(&cpu);
    try std.testing.expect(cpu.registers.getCarryFlag());
    try std.testing.expect(!cpu.registers.getSubtractionFlag());
    try std.testing.expect(!cpu.registers.getHalfCarryFlag());
}

test "ccf" {
    var rom: [0x8000]u8 = [_]u8{0} ** 0x8000;
    var cart = Cartridge.init(rom[0..]);
    var mmu = Mmu.init(&cart);
    var cycle_manager = CycleManager.init();
    var cpu = Cpu.init(&mmu, &cycle_manager);
    instructions.scf(&cpu);
    instructions.ccf(&cpu);
    try std.testing.expect(!cpu.registers.getCarryFlag());
    instructions.ccf(&cpu);
    try std.testing.expect(cpu.registers.getCarryFlag());
}

test "jr" {
    var rom: [0x8000]u8 = [_]u8{0} ** 0x8000;
    var cart = Cartridge.init(rom[0..]);
    var mmu = Mmu.init(&cart);
    var cycle_manager = CycleManager.init();
    var cpu = Cpu.init(&mmu, &cycle_manager);
    cpu.pc = 0x100;
    instructions.jr(&cpu, 0x10, true);
    try std.testing.expect(cpu.pc == 0x110);

    cpu.pc = 0x100;
    instructions.jr(&cpu, -0x10, true);
    try std.testing.expect(cpu.pc == 0xF0);
}

test "jp" {
    var rom: [0x8000]u8 = [_]u8{0} ** 0x8000;
    var cart = Cartridge.init(rom[0..]);
    var mmu = Mmu.init(&cart);
    var cycle_manager = CycleManager.init();
    var cpu = Cpu.init(&mmu, &cycle_manager);
    instructions.jp(&cpu, 0x1234, true);
    try std.testing.expect(cpu.pc == 0x1234);

    cpu.pc = 0x100;
    instructions.jp(&cpu, 0x2000, false);
    try std.testing.expect(cpu.pc == 0x100);
}

test "addSigned" {
    var rom: [0x8000]u8 = [_]u8{0} ** 0x8000;
    var cart = Cartridge.init(rom[0..]);
    var mmu = Mmu.init(&cart);
    var cycle_manager = CycleManager.init();
    var cpu = Cpu.init(&mmu, &cycle_manager);
    cpu.sp = 0xFFF8;

    instructions.addSigned(&cpu, &cpu.sp, 8);
    try std.testing.expect(cpu.sp == 0x0000);
    try std.testing.expect(!cpu.registers.getZeroFlag());
    try std.testing.expect(!cpu.registers.getSubtractionFlag());
    try std.testing.expect(cpu.registers.getHalfCarryFlag());
    try std.testing.expect(cpu.registers.getCarryFlag());

    cpu.sp = 0x0004;
    instructions.addSigned(&cpu, &cpu.sp, -8);
    try std.testing.expect(cpu.sp == 0xFFFC);
    try std.testing.expect(!cpu.registers.getZeroFlag());
    try std.testing.expect(!cpu.registers.getSubtractionFlag());
    try std.testing.expect(!cpu.registers.getHalfCarryFlag());
    try std.testing.expect(!cpu.registers.getCarryFlag());

    cpu.sp = 0x8000;
    instructions.addSigned(&cpu, &cpu.sp, 127);
    try std.testing.expect(cpu.sp == 0x807F);
    try std.testing.expect(!cpu.registers.getZeroFlag());
    try std.testing.expect(!cpu.registers.getSubtractionFlag());
    try std.testing.expect(!cpu.registers.getHalfCarryFlag());
    try std.testing.expect(!cpu.registers.getCarryFlag());

    cpu.sp = 0x8000;
    instructions.addSigned(&cpu, &cpu.sp, -128);
    try std.testing.expect(cpu.sp == 0x7F80);
    try std.testing.expect(!cpu.registers.getZeroFlag());
    try std.testing.expect(!cpu.registers.getSubtractionFlag());
    try std.testing.expect(!cpu.registers.getHalfCarryFlag());
    try std.testing.expect(!cpu.registers.getCarryFlag());
}
