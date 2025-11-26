const Cpu = @import("cpu.zig").Cpu;

pub fn add(cpu: *Cpu, target: *u8, value: u8) void {
    const result = @addWithOverflow(target.*, value);

    cpu.registers.setZeroFlag(result[0] == 0);
    cpu.registers.setSubtractionFlag(false);
    cpu.registers.setCarryFlag(result[1] != 0);
    cpu.registers.setHalfCarryFlag((target.* & 0x0F) + (value & 0xF) > 0x0F);
    target.* = result[0];
}

pub fn addWords(cpu: *Cpu, target: *u16, value: u16) void {
    const result = @addWithOverflow(target.*, value);

    cpu.registers.setSubtractionFlag(false);
    cpu.registers.setCarryFlag(result[1] != 0);
    cpu.registers.setHalfCarryFlag((target.* & 0x0FFF) + (value & 0x0FFF) > 0x0FFF);
    target.* = result[0];
}

pub fn adc(cpu: *Cpu, target: *u8, value: u8) void {
    const carry_flag_value = @as(u8, cpu.registers.getCarryFlagValue());
    const add_value_result = @addWithOverflow(target.*, value);
    const add_carry_result = @addWithOverflow(add_value_result[0], carry_flag_value);

    cpu.registers.setZeroFlag(add_carry_result[0] == 0);
    cpu.registers.setSubtractionFlag(false);
    cpu.registers.setCarryFlag(add_value_result[1] != 0 or add_carry_result[1] != 0);
    cpu.registers.setHalfCarryFlag((target.* & 0x0F) + (value & 0x0F) + carry_flag_value > 0x0F);
    target.* = add_carry_result[0];
}

pub fn sub(cpu: *Cpu, target: *u8, value: u8) void {
    const result = @subWithOverflow(target.*, value);

    cpu.registers.setZeroFlag(result[0] == 0);
    cpu.registers.setSubtractionFlag(true);
    cpu.registers.setCarryFlag(target.* < value);
    cpu.registers.setHalfCarryFlag((target.* & 0x0F) < (value & 0x0F));
    target.* = result[0];
}

pub fn sbc(cpu: *Cpu, target: *u8, value: u8) void {
    const carry_flag_value = @as(u8, cpu.registers.getCarryFlagValue());
    const sub_value_result = @subWithOverflow(target.*, value);
    const sub_carry_result = @subWithOverflow(sub_value_result[0], carry_flag_value);

    cpu.registers.setZeroFlag(sub_carry_result[0] == 0);
    cpu.registers.setSubtractionFlag(true);
    cpu.registers.setCarryFlag(@as(u9, target.*) < @as(u9, value) + carry_flag_value);
    cpu.registers.setHalfCarryFlag((target.* & 0x0F) < (value & 0x0F) + carry_flag_value);
    target.* = sub_carry_result[0];
}

pub fn andFn(cpu: *Cpu, target: *u8, value: u8) void {
    const result = target.* & value;

    cpu.registers.setZeroFlag(result == 0);
    cpu.registers.setSubtractionFlag(false);
    cpu.registers.setCarryFlag(false);
    cpu.registers.setHalfCarryFlag(true);
    target.* = result;
}

pub fn xor(cpu: *Cpu, target: *u8, value: u8) void {
    const result = target.* ^ value;

    cpu.registers.setZeroFlag(result == 0);
    cpu.registers.setSubtractionFlag(false);
    cpu.registers.setCarryFlag(false);
    cpu.registers.setHalfCarryFlag(false);
    target.* = result;
}

pub fn orFn(cpu: *Cpu, target: *u8, value: u8) void {
    const result = target.* | value;

    cpu.registers.setZeroFlag(result == 0);
    cpu.registers.setSubtractionFlag(false);
    cpu.registers.setCarryFlag(false);
    cpu.registers.setHalfCarryFlag(false);
    target.* = result;
}

pub fn cp(cpu: *Cpu, target: *u8, value: u8) void {
    const result = @subWithOverflow(target.*, value);

    cpu.registers.setZeroFlag(result[0] == 0);
    cpu.registers.setSubtractionFlag(true);
    cpu.registers.setCarryFlag(target.* < value);
    cpu.registers.setHalfCarryFlag((target.* & 0x0F) < (value & 0x0F));
}

pub fn inc(cpu: *Cpu, target: *u8) void {
    const result = @addWithOverflow(target.*, 1);

    cpu.registers.setZeroFlag(result[0] == 0);
    cpu.registers.setSubtractionFlag(false);
    cpu.registers.setHalfCarryFlag((target.* & 0x0F) + 1 > 0x0F);
    target.* = result[0];
}

pub fn dec(cpu: *Cpu, target: *u8) void {
    const result = @subWithOverflow(target.*, 1);

    cpu.registers.setZeroFlag(result[0] == 0);
    cpu.registers.setSubtractionFlag(true);
    cpu.registers.setHalfCarryFlag((target.* & 0x0F) < 1);
    target.* = result[0];
}

pub fn rlc(cpu: *Cpu, target: *u8) void {
    const high_bit = target.* >> 7;
    target.* = (target.* << 1) | high_bit;

    cpu.registers.setZeroFlag(target.* == 0);
    cpu.registers.setSubtractionFlag(false);
    cpu.registers.setHalfCarryFlag(false);
    cpu.registers.setCarryFlag(high_bit != 0);
}

pub fn rrc(cpu: *Cpu, target: *u8) void {
    const low_bit = target.* << 7;
    target.* = (target.* >> 1) | low_bit;

    cpu.registers.setZeroFlag(target.* == 0);
    cpu.registers.setSubtractionFlag(false);
    cpu.registers.setHalfCarryFlag(false);
    cpu.registers.setCarryFlag(low_bit != 0);
}
