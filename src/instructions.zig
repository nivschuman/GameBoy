const Cpu = @import("cpu.zig").Cpu;

pub fn add(cpu: *Cpu, register: *u8, value: u8) void {
    const result = @addWithOverflow(register.*, value);

    cpu.registers.setZeroFlag(result[0] == 0);
    cpu.registers.setSubtractionFlag(false);
    cpu.registers.setCarryFlag(result[1] != 0);
    cpu.registers.setHalfCarryFlag((register.* & 0x0F) + (value & 0xF) > 0x0F);
    register.* = result[0];
}

pub fn adc(cpu: *Cpu, register: *u8, value: u8) void {
    const carry_flag_value = @as(u8, cpu.registers.getCarryFlagValue());
    const add_value_result = @addWithOverflow(register.*, value);
    const add_carry_result = @addWithOverflow(add_value_result[0], carry_flag_value);

    cpu.registers.setZeroFlag(add_carry_result[0] == 0);
    cpu.registers.setSubtractionFlag(false);
    cpu.registers.setCarryFlag(add_value_result[1] != 0 or add_carry_result[1] != 0);
    cpu.registers.setHalfCarryFlag((register.* & 0x0F) + (value & 0x0F) + carry_flag_value > 0x0F);
    register.* = add_carry_result[0];
}

pub fn sub(cpu: *Cpu, register: *u8, value: u8) void {
    const result = @subWithOverflow(register.*, value);

    cpu.registers.setZeroFlag(result[0] == 0);
    cpu.registers.setSubtractionFlag(true);
    cpu.registers.setCarryFlag(register.* < value);
    cpu.registers.setHalfCarryFlag((register.* & 0x0F) < (value & 0x0F));
    register.* = result[0];
}

pub fn sbc(cpu: *Cpu, register: *u8, value: u8) void {
    const carry_flag_value = @as(u8, cpu.registers.getCarryFlagValue());
    const sub_value_result = @subWithOverflow(register.*, value);
    const sub_carry_result = @subWithOverflow(sub_value_result[0], carry_flag_value);

    cpu.registers.setZeroFlag(sub_carry_result[0] == 0);
    cpu.registers.setSubtractionFlag(true);
    cpu.registers.setCarryFlag(@as(u9, register.*) < @as(u9, value) + carry_flag_value);
    cpu.registers.setHalfCarryFlag((register.* & 0x0F) < (value & 0x0F) + carry_flag_value);
    register.* = sub_carry_result[0];
}

pub fn andFn(cpu: *Cpu, register: *u8, value: u8) void {
    const result = register.* & value;

    cpu.registers.setZeroFlag(result == 0);
    cpu.registers.setSubtractionFlag(false);
    cpu.registers.setCarryFlag(false);
    cpu.registers.setHalfCarryFlag(true);
    register.* = result;
}

pub fn xor(cpu: *Cpu, register: *u8, value: u8) void {
    const result = register.* ^ value;

    cpu.registers.setZeroFlag(result == 0);
    cpu.registers.setSubtractionFlag(false);
    cpu.registers.setCarryFlag(false);
    cpu.registers.setHalfCarryFlag(false);
    register.* = result;
}

pub fn orFn(cpu: *Cpu, register: *u8, value: u8) void {
    const result = register.* | value;

    cpu.registers.setZeroFlag(result == 0);
    cpu.registers.setSubtractionFlag(false);
    cpu.registers.setCarryFlag(false);
    cpu.registers.setHalfCarryFlag(false);
    register.* = result;
}

pub fn cp(cpu: *Cpu, register: *u8, value: u8) void {
    const result = @subWithOverflow(register.*, value);

    cpu.registers.setZeroFlag(result[0] == 0);
    cpu.registers.setSubtractionFlag(true);
    cpu.registers.setCarryFlag(register.* < value);
    cpu.registers.setHalfCarryFlag((register.* & 0x0F) < (value & 0x0F));
}

pub fn inc(cpu: *Cpu, register: *u8) void {
    const result = @addWithOverflow(register.*, 1);

    cpu.registers.setZeroFlag(result[0] == 0);
    cpu.registers.setSubtractionFlag(false);
    cpu.registers.setHalfCarryFlag((register.* & 0x0F) + 1 > 0x0F);
    register.* = result[0];
}

pub fn dec(cpu: *Cpu, register: *u8) void {
    const result = @subWithOverflow(register.*, 1);

    cpu.registers.setZeroFlag(result[0] == 0);
    cpu.registers.setSubtractionFlag(true);
    cpu.registers.setHalfCarryFlag((register.* & 0x0F) < 1);
    register.* = result[0];
}

pub fn rlc(cpu: *Cpu, register: *u8) void {
    const highBit = register.* >> 7;
    register.* = (register.* << 1) | highBit;

    cpu.registers.setZeroFlag(register.* == 0);
    cpu.registers.setSubtractionFlag(false);
    cpu.registers.setHalfCarryFlag(false);
    cpu.registers.setCarryFlag(highBit != 0);
}
