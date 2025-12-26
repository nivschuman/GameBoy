const std = @import("std");
const Registers = @import("registers/registers.zig").Registers;
const Mmu = @import("../mmu/mmu.zig").Mmu;
const CycleManager = @import("../cycles/cycles.zig").CycleManager;
const Cycles = @import("../cycles/cycles.zig").Cycles;
const InterruptRegisters = @import("interrupts/interrupts.zig").InterruptRegisters;
const opcodes_table = @import("opcodes.zig").opcodes_table;
const opcode_names = @import("opcodes.zig").opcode_names;
const opcodes_cb_names = @import("opcodes_cb.zig").opcodes_cb_names;
const call = @import("instructions.zig").call;

const logger = std.log.scoped(.cpu);

pub const Cpu = struct {
    registers: Registers,
    pc: u16,
    sp: u16,
    interrupt_master_enable: bool,
    set_interrupt_master_enable: bool,
    halted: bool,
    mmu: *Mmu,
    cycle_manager: *CycleManager,
    interrupt_registers: *InterruptRegisters,

    pub fn init(mmu: *Mmu, cycle_manager: *CycleManager, interrupt_registers: *InterruptRegisters) Cpu {
        return .{
            .registers = Registers.init(),
            .pc = 0x100,
            .sp = 0xFFFE,
            .interrupt_master_enable = false,
            .set_interrupt_master_enable = false,
            .mmu = mmu,
            .cycle_manager = cycle_manager,
            .halted = false,
            .interrupt_registers = interrupt_registers,
        };
    }

    pub fn opcode(self: *const Cpu) u8 {
        return self.readByte(self.pc);
    }

    pub fn d8(self: *const Cpu) u8 {
        return self.readByte(self.pc +% 1);
    }

    pub fn s8(self: *const Cpu) i8 {
        return self.readSignedByte(self.pc +% 1);
    }

    pub fn d16(self: *const Cpu) u16 {
        return self.readWord(self.pc +% 1);
    }

    pub fn readByte(self: *const Cpu, address: u16) u8 {
        const result = self.mmu.readByte(address);
        self.cycle(1);
        return result;
    }

    pub fn readSignedByte(self: *const Cpu, address: u16) i8 {
        const result = self.mmu.readSignedByte(address);
        self.cycle(1);
        return result;
    }

    pub fn readWord(self: *const Cpu, address: u16) u16 {
        const result = self.mmu.readWord(address);
        self.cycle(2);
        return result;
    }

    pub fn writeByte(self: *Cpu, address: u16, value: u8) void {
        self.mmu.writeByte(address, value);
        self.cycle(1);
    }

    pub fn writeWord(self: *Cpu, address: u16, value: u16) void {
        self.mmu.writeWord(address, value);
        self.cycle(2);
    }

    pub fn executeInstruction(self: *Cpu) void {
        const op = self.opcode();
        if (op == 0xCB) {
            const op_cb = self.mmu.readByte(self.pc +% 1);
            logger.info("executing CB opcode 0x{X}: {s}", .{ op_cb, opcodes_cb_names[op_cb] });
        } else {
            logger.info("executing opcode 0x{X}: {s}", .{ op, opcode_names[op] });
        }
        opcodes_table[op](self);
    }

    pub fn executeInterrupt(self: *Cpu) void {
        if (self.interrupt_registers.getInterruptToHandle()) |interrupt| {
            call(self, interrupt.getAddress(), true);
            self.interrupt_registers.setSpecifiedInterruptFlag(interrupt, false);
            self.halted = false;
            self.interrupt_master_enable = false;
        }
    }

    pub fn cycle(self: *const Cpu, cycles: Cycles) void {
        self.cycle_manager.cycle(cycles);
    }

    pub fn step(self: *Cpu) void {
        if (self.halted) {
            self.cycle_manager.cycle(1);
            self.halted = self.interrupt_registers.interrupt_enable & self.interrupt_registers.interrupt_flag != 0;
        } else {
            self.executeInstruction();
        }

        if (self.interrupt_master_enable) {
            self.executeInterrupt();
        }

        if (self.set_interrupt_master_enable) {
            self.interrupt_master_enable = true;
        }
    }
};
