const Cpu = @import("cpu.zig").Cpu;
const Instructions = @import("instructions.zig");

pub fn opcode00(cpu: *Cpu) void {
    cpu.pc += 1;
}

pub fn opcode80(cpu: *Cpu) void {
    Instructions.add(cpu, cpu.registers.b);
    cpu.pc += 1;
}

pub fn opcode81(cpu: *Cpu) void {
    Instructions.add(cpu, cpu.registers.c);
    cpu.pc += 1;
}

pub fn opcode82(cpu: *Cpu) void {
    Instructions.add(cpu, cpu.registers.d);
    cpu.pc += 1;
}

pub fn opcode83(cpu: *Cpu) void {
    Instructions.add(cpu, cpu.registers.e);
    cpu.pc += 1;
}

pub fn opcode84(cpu: *Cpu) void {
    Instructions.add(cpu, cpu.registers.h);
    cpu.pc += 1;
}

pub fn opcode85(cpu: *Cpu) void {
    Instructions.add(cpu, cpu.registers.l);
    cpu.pc += 1;
}

pub fn opcode86(cpu: *Cpu) void {
    Instructions.add(cpu, cpu.memory.readByte(cpu.registers.getHL()));
    cpu.pc += 1;
}

pub fn opcode87(cpu: *Cpu) void {
    Instructions.add(cpu, cpu.registers.a);
    cpu.pc += 1;
}

pub fn opcode88(cpu: *Cpu) void {
    Instructions.adc(cpu, cpu.registers.b);
    cpu.pc += 1;
}

pub fn opcode89(cpu: *Cpu) void {
    Instructions.adc(cpu, cpu.registers.c);
    cpu.pc += 1;
}

pub fn opcode8A(cpu: *Cpu) void {
    Instructions.adc(cpu, cpu.registers.d);
    cpu.pc += 1;
}

pub fn opcode8B(cpu: *Cpu) void {
    Instructions.adc(cpu, cpu.registers.e);
    cpu.pc += 1;
}

pub fn opcode8C(cpu: *Cpu) void {
    Instructions.adc(cpu, cpu.registers.h);
    cpu.pc += 1;
}

pub fn opcode8D(cpu: *Cpu) void {
    Instructions.adc(cpu, cpu.registers.l);
    cpu.pc += 1;
}

pub fn opcode8E(cpu: *Cpu) void {
    Instructions.adc(cpu, cpu.memory.readByte(cpu.registers.getHL()));
    cpu.pc += 1;
}

pub fn opcode8F(cpu: *Cpu) void {
    Instructions.adc(cpu, cpu.registers.a);
    cpu.pc += 1;
}

pub fn opcode90(cpu: *Cpu) void {
    Instructions.sub(cpu, cpu.registers.b);
    cpu.pc += 1;
}

pub fn opcode91(cpu: *Cpu) void {
    Instructions.sub(cpu, cpu.registers.c);
    cpu.pc += 1;
}

pub fn opcode92(cpu: *Cpu) void {
    Instructions.sub(cpu, cpu.registers.d);
    cpu.pc += 1;
}

pub fn opcode93(cpu: *Cpu) void {
    Instructions.sub(cpu, cpu.registers.e);
    cpu.pc += 1;
}

pub fn opcode94(cpu: *Cpu) void {
    Instructions.sub(cpu, cpu.registers.h);
    cpu.pc += 1;
}

pub fn opcode95(cpu: *Cpu) void {
    Instructions.sub(cpu, cpu.registers.l);
    cpu.pc += 1;
}

pub fn opcode96(cpu: *Cpu) void {
    Instructions.sub(cpu, cpu.memory.readByte(cpu.registers.getHL()));
    cpu.pc += 1;
}

pub fn opcode97(cpu: *Cpu) void {
    Instructions.sub(cpu, cpu.registers.a);
    cpu.pc += 1;
}

pub fn opcode98(cpu: *Cpu) void {
    Instructions.sbc(cpu, cpu.registers.b);
    cpu.pc += 1;
}

pub fn opcode99(cpu: *Cpu) void {
    Instructions.sbc(cpu, cpu.registers.c);
    cpu.pc += 1;
}

pub fn opcode9A(cpu: *Cpu) void {
    Instructions.sbc(cpu, cpu.registers.d);
    cpu.pc += 1;
}

pub fn opcode9B(cpu: *Cpu) void {
    Instructions.sbc(cpu, cpu.registers.e);
    cpu.pc += 1;
}

pub fn opcode9C(cpu: *Cpu) void {
    Instructions.sbc(cpu, cpu.registers.h);
    cpu.pc += 1;
}

pub fn opcode9D(cpu: *Cpu) void {
    Instructions.sbc(cpu, cpu.registers.l);
    cpu.pc += 1;
}

pub fn opcode9E(cpu: *Cpu) void {
    Instructions.sbc(cpu, cpu.memory.readByte(cpu.registers.getHL()));
    cpu.pc += 1;
}

pub fn opcode9F(cpu: *Cpu) void {
    Instructions.sbc(cpu, cpu.registers.a);
    cpu.pc += 1;
}

pub fn opcodeA0(cpu: *Cpu) void {
    Instructions.andFn(cpu, cpu.registers.b);
    cpu.pc += 1;
}

pub fn opcodeA1(cpu: *Cpu) void {
    Instructions.andFn(cpu, cpu.registers.c);
    cpu.pc += 1;
}

pub fn opcodeA2(cpu: *Cpu) void {
    Instructions.andFn(cpu, cpu.registers.d);
    cpu.pc += 1;
}

pub fn opcodeA3(cpu: *Cpu) void {
    Instructions.andFn(cpu, cpu.registers.e);
    cpu.pc += 1;
}

pub fn opcodeA4(cpu: *Cpu) void {
    Instructions.andFn(cpu, cpu.registers.h);
    cpu.pc += 1;
}

pub fn opcodeA5(cpu: *Cpu) void {
    Instructions.andFn(cpu, cpu.registers.l);
    cpu.pc += 1;
}

pub fn opcodeA6(cpu: *Cpu) void {
    Instructions.andFn(cpu, cpu.memory.readByte(cpu.registers.getHL()));
    cpu.pc += 1;
}

pub fn opcodeA7(cpu: *Cpu) void {
    Instructions.andFn(cpu, cpu.registers.a);
    cpu.pc += 1;
}

pub fn opcodeA8(cpu: *Cpu) void {
    Instructions.xor(cpu, cpu.registers.b);
    cpu.pc += 1;
}

pub fn opcodeA9(cpu: *Cpu) void {
    Instructions.xor(cpu, cpu.registers.c);
    cpu.pc += 1;
}

pub fn opcodeAA(cpu: *Cpu) void {
    Instructions.xor(cpu, cpu.registers.d);
    cpu.pc += 1;
}

pub fn opcodeAB(cpu: *Cpu) void {
    Instructions.xor(cpu, cpu.registers.e);
    cpu.pc += 1;
}

pub fn opcodeAC(cpu: *Cpu) void {
    Instructions.xor(cpu, cpu.registers.h);
    cpu.pc += 1;
}

pub fn opcodeAD(cpu: *Cpu) void {
    Instructions.xor(cpu, cpu.registers.l);
    cpu.pc += 1;
}

pub fn opcodeAE(cpu: *Cpu) void {
    Instructions.xor(cpu, cpu.memory.readByte(cpu.registers.getHL()));
    cpu.pc += 1;
}

pub fn opcodeAF(cpu: *Cpu) void {
    Instructions.xor(cpu, cpu.registers.a);
    cpu.pc += 1;
}

pub fn opcodeB0(cpu: *Cpu) void {
    Instructions.orFn(cpu, cpu.registers.b);
    cpu.pc += 1;
}

pub fn opcodeB1(cpu: *Cpu) void {
    Instructions.orFn(cpu, cpu.registers.c);
    cpu.pc += 1;
}

pub fn opcodeB2(cpu: *Cpu) void {
    Instructions.orFn(cpu, cpu.registers.d);
    cpu.pc += 1;
}

pub fn opcodeB3(cpu: *Cpu) void {
    Instructions.orFn(cpu, cpu.registers.e);
    cpu.pc += 1;
}

pub fn opcodeB4(cpu: *Cpu) void {
    Instructions.orFn(cpu, cpu.registers.h);
    cpu.pc += 1;
}

pub fn opcodeB5(cpu: *Cpu) void {
    Instructions.orFn(cpu, cpu.registers.l);
    cpu.pc += 1;
}

pub fn opcodeB6(cpu: *Cpu) void {
    Instructions.orFn(cpu, cpu.memory.readByte(cpu.registers.getHL()));
    cpu.pc += 1;
}

pub fn opcodeB7(cpu: *Cpu) void {
    Instructions.orFn(cpu, cpu.registers.a);
    cpu.pc += 1;
}

pub fn opcodeB8(cpu: *Cpu) void {
    Instructions.cp(cpu, cpu.registers.b);
    cpu.pc += 1;
}

pub fn opcodeB9(cpu: *Cpu) void {
    Instructions.cp(cpu, cpu.registers.c);
    cpu.pc += 1;
}

pub fn opcodeBA(cpu: *Cpu) void {
    Instructions.cp(cpu, cpu.registers.d);
    cpu.pc += 1;
}

pub fn opcodeBB(cpu: *Cpu) void {
    Instructions.cp(cpu, cpu.registers.e);
    cpu.pc += 1;
}

pub fn opcodeBC(cpu: *Cpu) void {
    Instructions.cp(cpu, cpu.registers.h);
    cpu.pc += 1;
}

pub fn opcodeBD(cpu: *Cpu) void {
    Instructions.cp(cpu, cpu.registers.l);
    cpu.pc += 1;
}

pub fn opcodeBE(cpu: *Cpu) void {
    Instructions.cp(cpu, cpu.memory.readByte(cpu.registers.getHL()));
    cpu.pc += 1;
}

pub fn opcodeBF(cpu: *Cpu) void {
    Instructions.cp(cpu, cpu.registers.a);
    cpu.pc += 1;
}
