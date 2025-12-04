const Cpu = @import("types/cpu.zig").Cpu;

pub fn add(cpu: *Cpu, target: *u8, value: u8) void {
    const result = @addWithOverflow(target.*, value);

    cpu.registers.setZeroFlag(result[0] == 0);
    cpu.registers.setSubtractionFlag(false);
    cpu.registers.setCarryFlag(result[1] != 0);
    cpu.registers.setHalfCarryFlag((target.* & 0x0F) + (value & 0x0F) > 0x0F);
    target.* = result[0];
}

pub fn addWords(cpu: *Cpu, target: *u16, value: u16) void {
    const result = @addWithOverflow(target.*, value);

    cpu.registers.setSubtractionFlag(false);
    cpu.registers.setCarryFlag(result[1] != 0);
    cpu.registers.setHalfCarryFlag((target.* & 0x0FFF) + (value & 0x0FFF) > 0x0FFF);
    target.* = result[0];
}

pub fn addSigned(cpu: *Cpu, target: *u16, value: i8) void {
    const value_u16: u16 = @as(u16, @bitCast(@as(i16, value)));
    const result = target.* +% value_u16;
    const xor_result = target.* ^ value_u16 ^ result;

    cpu.registers.setZeroFlag(false);
    cpu.registers.setSubtractionFlag(false);
    cpu.registers.setHalfCarryFlag(xor_result & 0x10 != 0);
    cpu.registers.setCarryFlag(xor_result & 0x100 != 0);
    target.* = result;
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
    const result = target.* -% value;

    cpu.registers.setZeroFlag(result == 0);
    cpu.registers.setSubtractionFlag(true);
    cpu.registers.setCarryFlag(target.* < value);
    cpu.registers.setHalfCarryFlag((target.* & 0x0F) < (value & 0x0F));
    target.* = result;
}

pub fn sbc(cpu: *Cpu, target: *u8, value: u8) void {
    const carry_flag_value = @as(u8, cpu.registers.getCarryFlagValue());
    const result = target.* -% value -% carry_flag_value;

    cpu.registers.setZeroFlag(result == 0);
    cpu.registers.setSubtractionFlag(true);
    cpu.registers.setCarryFlag(@as(u9, target.*) < @as(u9, value) + carry_flag_value);
    cpu.registers.setHalfCarryFlag((target.* & 0x0F) < (value & 0x0F) + carry_flag_value);
    target.* = result;
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
    const result = target.* -% value;

    cpu.registers.setZeroFlag(result == 0);
    cpu.registers.setSubtractionFlag(true);
    cpu.registers.setCarryFlag(target.* < value);
    cpu.registers.setHalfCarryFlag((target.* & 0x0F) < (value & 0x0F));
}

pub fn inc(cpu: *Cpu, target: *u8) void {
    const result = target.* +% 1;

    cpu.registers.setZeroFlag(result == 0);
    cpu.registers.setSubtractionFlag(false);
    cpu.registers.setHalfCarryFlag((target.* & 0x0F) + 1 > 0x0F);
    target.* = result;
}

pub fn dec(cpu: *Cpu, target: *u8) void {
    const result = target.* -% 1;

    cpu.registers.setZeroFlag(result == 0);
    cpu.registers.setSubtractionFlag(true);
    cpu.registers.setHalfCarryFlag((target.* & 0x0F) < 1);
    target.* = result;
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

pub fn rl(cpu: *Cpu, target: *u8) void {
    const high_bit = target.* >> 7;
    target.* = (target.* << 1) | @as(u8, cpu.registers.getCarryFlagValue());

    cpu.registers.setZeroFlag(target.* == 0);
    cpu.registers.setSubtractionFlag(false);
    cpu.registers.setHalfCarryFlag(false);
    cpu.registers.setCarryFlag(high_bit != 0);
}

pub fn rr(cpu: *Cpu, target: *u8) void {
    const low_bit = target.* & 0x01;
    target.* = (target.* >> 1) | (@as(u8, cpu.registers.getCarryFlagValue()) << 7);

    cpu.registers.setZeroFlag(target.* == 0);
    cpu.registers.setSubtractionFlag(false);
    cpu.registers.setHalfCarryFlag(false);
    cpu.registers.setCarryFlag(low_bit != 0);
}

pub fn sla(cpu: *Cpu, target: *u8) void {
    const high_bit = target.* >> 7;
    target.* <<= 1;

    cpu.registers.setZeroFlag(target.* == 0);
    cpu.registers.setSubtractionFlag(false);
    cpu.registers.setHalfCarryFlag(false);
    cpu.registers.setCarryFlag(high_bit != 0);
}

pub fn sra(cpu: *Cpu, target: *u8) void {
    const low_bit = target.* & 0x01;
    target.* = (target.* >> 1) | (target.* & 0x80);

    cpu.registers.setZeroFlag(target.* == 0);
    cpu.registers.setSubtractionFlag(false);
    cpu.registers.setHalfCarryFlag(false);
    cpu.registers.setCarryFlag(low_bit != 0);
}

pub fn swap(cpu: *Cpu, target: *u8) void {
    const low_bits = target.* & 0x0F;
    const high_bits = target.* & 0xF0;
    target.* = (low_bits << 4) | (high_bits >> 4);

    cpu.registers.setZeroFlag(target.* == 0);
    cpu.registers.setSubtractionFlag(false);
    cpu.registers.setHalfCarryFlag(false);
    cpu.registers.setCarryFlag(false);
}

pub fn srl(cpu: *Cpu, target: *u8) void {
    const low_bit = target.* & 0x01;
    target.* >>= 1;

    cpu.registers.setZeroFlag(target.* == 0);
    cpu.registers.setSubtractionFlag(false);
    cpu.registers.setHalfCarryFlag(false);
    cpu.registers.setCarryFlag(low_bit != 0);
}

pub fn cpl(cpu: *Cpu, target: *u8) void {
    target.* ^= 0xFF;

    cpu.registers.setSubtractionFlag(true);
    cpu.registers.setHalfCarryFlag(true);
}

pub fn scf(cpu: *Cpu) void {
    cpu.registers.setCarryFlag(true);
    cpu.registers.setSubtractionFlag(false);
    cpu.registers.setHalfCarryFlag(false);
}

pub fn ccf(cpu: *Cpu) void {
    cpu.registers.setSubtractionFlag(false);
    cpu.registers.setHalfCarryFlag(false);
    cpu.registers.setCarryFlag(!cpu.registers.getCarryFlag());
}

pub fn bit(cpu: *Cpu, position: u3, value: u8) void {
    cpu.registers.setZeroFlag(value & (0x01 << @as(u8, position)) == 0);
    cpu.registers.setSubtractionFlag(false);
    cpu.registers.setHalfCarryFlag(true);
}

pub fn jr(cpu: *Cpu, value: i8, should_jump: bool) void {
    if (!should_jump) {
        return;
    }

    if (value < 0) {
        cpu.pc -%= @abs(value);
        return;
    }

    cpu.pc +%= @abs(value);
}

pub fn jp(cpu: *Cpu, address: u16, should_jump: bool) void {
    if (!should_jump) {
        return;
    }

    cpu.pc = address;
}

pub fn ret(cpu: *Cpu, should_ret: bool) void {
    if (!should_ret) {
        return;
    }

    cpu.pc = pop(cpu);
}

pub fn pop(cpu: *Cpu) u16 {
    const result = cpu.memory.readWord(cpu.sp);
    cpu.sp +%= 2;
    return result;
}

pub fn push(cpu: *Cpu, value: u16) void {
    cpu.sp -%= 2;
    cpu.memory.writeWord(cpu.sp, value);
}

pub fn call(cpu: *Cpu, address: u16, should_call: bool) void {
    if (!should_call) {
        return;
    }

    push(cpu, cpu.pc);
    cpu.pc = address;
}

pub fn ld(_: *Cpu, target: *u8, value: u8) void {
    target.* = value;
}

pub fn ldIntoRam(cpu: *Cpu, offset: u8, value: u8) void {
    const address = 0xFF00 + @as(u16, offset);
    cpu.memory.writeByte(address, value);
}

pub fn ldRamInto(cpu: *Cpu, target: *u8, offset: u8) void {
    const address = 0xFF00 + @as(u16, offset);
    target.* = cpu.memory.readByte(address);
}
