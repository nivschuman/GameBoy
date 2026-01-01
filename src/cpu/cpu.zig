const Registers = @import("registers/registers.zig").Registers;
const Mmu = @import("../mmu/mmu.zig").Mmu;
const CycleManager = @import("../cycles/cycles.zig").CycleManager;
const Cycle = @import("../cycles/cycles.zig").Cycle;
const Io = @import("../io/io.zig").Io;
const opcodes_table = @import("opcodes.zig").opcodes_table;
const call = @import("instructions.zig").call;

pub const Cpu = struct {
    registers: Registers,
    pc: u16,
    sp: u16,
    interrupt_master_enable: bool,
    set_interrupt_master_enable: bool,
    halted: bool,
    mmu: *Mmu,
    cycle_manager: *CycleManager,
    io: *Io,

    pub fn init(mmu: *Mmu, cycle_manager: *CycleManager, io: *Io) Cpu {
        return .{
            .registers = Registers.init(),
            .pc = 0x100,
            .sp = 0xFFFE,
            .interrupt_master_enable = false,
            .set_interrupt_master_enable = false,
            .mmu = mmu,
            .cycle_manager = cycle_manager,
            .halted = false,
            .io = io,
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
        const low = self.readByte(address);
        const high = self.readByte(address + 1);
        return (@as(u16, high) << 8) | (@as(u16, low));
    }

    pub fn writeByte(self: *Cpu, address: u16, value: u8) void {
        self.mmu.writeByte(address, value);
        self.cycle(1);
    }

    pub fn writeWord(self: *Cpu, address: u16, value: u16) void {
        const low = @as(u8, @truncate(value));
        const high = @as(u8, @truncate(value >> 8));
        self.writeByte(address, low);
        self.writeByte(address + 1, high);
    }

    pub fn executeInstruction(self: *Cpu) void {
        opcodes_table[self.opcode()](self);
    }

    pub fn executeInterrupt(self: *Cpu) void {
        if (self.io.interrupt_registers.getInterruptToHandle()) |interrupt| {
            call(self, interrupt.getAddress(), true);
            self.io.interrupt_registers.setSpecifiedInterruptFlag(interrupt, false);
            self.halted = false;
            self.interrupt_master_enable = false;
        }
    }

    pub fn cycle(self: *const Cpu, cycles: Cycle) void {
        self.cycle_manager.cycle(cycles);
    }

    pub fn step(self: *Cpu) void {
        if (self.halted) {
            self.cycle_manager.cycle(1);
            self.halted = self.io.interrupt_registers.interrupt_flag == 0;
        } else {
            self.executeInstruction();
        }

        if (self.interrupt_master_enable) {
            self.executeInterrupt();
            self.set_interrupt_master_enable = false;
        }

        if (self.set_interrupt_master_enable) {
            self.interrupt_master_enable = true;
        }
    }
};
