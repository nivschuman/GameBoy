const Cpu = @import("cpu.zig").Cpu;

pub fn add(cpu: *Cpu, value: u8) void {
    const result = @addWithOverflow(cpu.registers.a, value);

    cpu.registers.setZeroFlag(result[0] == 0);
    cpu.registers.setSubtractionFlag(false);
    cpu.registers.setCarryFlag(result[1] != 0);
    cpu.registers.setHalfCarryFlag((cpu.registers.a & 0x0F) + (value & 0xF) > 0x0F);
    cpu.registers.a = result[0];
}

pub fn adc(cpu: *Cpu, value: u8) void {
    const carry_flag_value = @as(u8, cpu.registers.getCarryFlagValue());
    const add_value_result = @addWithOverflow(cpu.registers.a, value);
    const add_carry_result = @addWithOverflow(add_value_result[0], carry_flag_value);

    cpu.registers.setZeroFlag(add_carry_result[0] == 0);
    cpu.registers.setSubtractionFlag(false);
    cpu.registers.setCarryFlag(add_value_result[1] != 0 or add_carry_result[1] != 0);
    cpu.registers.setHalfCarryFlag((cpu.registers.a & 0x0F) + (value & 0x0F) + carry_flag_value > 0x0F);
    cpu.registers.a = add_carry_result[0];
}

pub fn sub(cpu: *Cpu, value: u8) void {
    const result = @subWithOverflow(cpu.registers.a, value);

    cpu.registers.setZeroFlag(result[0] == 0);
    cpu.registers.setSubtractionFlag(true);
    cpu.registers.setCarryFlag(cpu.registers.a < value);
    cpu.registers.setHalfCarryFlag((cpu.registers.a & 0x0F) < (value & 0x0F));
    cpu.registers.a = result[0];
}

pub fn sbc(cpu: *Cpu, value: u8) void {
    const carry_flag_value = @as(u8, cpu.registers.getCarryFlagValue());
    const sub_value_result = @subWithOverflow(cpu.registers.a, value);
    const sub_carry_result = @subWithOverflow(sub_value_result[0], carry_flag_value);

    cpu.registers.setZeroFlag(sub_carry_result[0] == 0);
    cpu.registers.setSubtractionFlag(true);
    cpu.registers.setCarryFlag(@as(u9, cpu.registers.a) < @as(u9, value) + carry_flag_value);
    cpu.registers.setHalfCarryFlag((cpu.registers.a & 0x0F) < (value & 0x0F) + carry_flag_value);
    cpu.registers.a = sub_carry_result[0];
}
