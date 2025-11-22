const Cpu = @import("cpu.zig").Cpu;

pub fn add(cpu: *Cpu, value: u8) void {
    const result = @addWithOverflow(cpu.registers.a, value);

    cpu.registers.setZeroFlag(result[0] == 0);
    cpu.registers.setSubtractionFlag(false);
    cpu.registers.setCarryFlag(result[1] != 0);
    cpu.registers.setHalfCarryFlag((cpu.registers.a & 0xF) + (value & 0xF) > 0xF);
    cpu.registers.a = result[0];
}

pub fn adc(cpu: *Cpu, value: u8) void {
    const carry_flag_value = @as(u8, @intFromBool(cpu.registers.getCarryFlag()));
    const add_value_result = @addWithOverflow(cpu.registers.a, value);
    const add_carry_result = @addWithOverflow(add_value_result[0], carry_flag_value);

    cpu.registers.setZeroFlag(add_carry_result[0] == 0);
    cpu.registers.setSubtractionFlag(false);
    cpu.registers.setCarryFlag(add_value_result[1] != 0 or add_carry_result[1] != 0);
    cpu.registers.setHalfCarryFlag((cpu.registers.a & 0xF) + (value & 0xF) + carry_flag_value > 0xF);
    cpu.registers.a = add_carry_result[0];
}
