const Cpu = @import("cpu.zig").Cpu;
const Instructions = @import("instructions.zig");

pub fn opcode80(cpu: *Cpu) void {
    Instructions.add(cpu, cpu.registers.b);
}

pub fn opcode81(cpu: *Cpu) void {
    Instructions.add(cpu, cpu.registers.c);
}

pub fn opcode82(cpu: *Cpu) void {
    Instructions.add(cpu, cpu.registers.d);
}

pub fn opcode83(cpu: *Cpu) void {
    Instructions.add(cpu, cpu.registers.e);
}

pub fn opcode84(cpu: *Cpu) void {
    Instructions.add(cpu, cpu.registers.h);
}

pub fn opcode85(cpu: *Cpu) void {
    Instructions.add(cpu, cpu.registers.l);
}

pub fn opcode87(cpu: *Cpu) void {
    Instructions.add(cpu, cpu.registers.a);
}

pub fn opcode88(cpu: *Cpu) void {
    Instructions.adc(cpu, cpu.registers.b);
}

pub fn opcode89(cpu: *Cpu) void {
    Instructions.adc(cpu, cpu.registers.c);
}

pub fn opcode8A(cpu: *Cpu) void {
    Instructions.adc(cpu, cpu.registers.d);
}

pub fn opcode8B(cpu: *Cpu) void {
    Instructions.adc(cpu, cpu.registers.e);
}

pub fn opcode8C(cpu: *Cpu) void {
    Instructions.adc(cpu, cpu.registers.h);
}

pub fn opcode8D(cpu: *Cpu) void {
    Instructions.adc(cpu, cpu.registers.l);
}

pub fn opcode8F(cpu: *Cpu) void {
    Instructions.adc(cpu, cpu.registers.a);
}
