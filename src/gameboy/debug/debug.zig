const Serial = @import("../../io/serial/serial.zig").Serial;
const Cpu = @import("../../cpu/cpu.zig").Cpu;
const opcode_names = @import("../../cpu/opcodes.zig").opcode_names;
const opcodes_cb_names = @import("../../cpu/opcodes_cb.zig").opcodes_cb_names;
const std = @import("std");
const c = @cImport({
    @cInclude("stdio.h");
});

pub const DebugMode = enum {
    DebugStep,
    DebugLog,
    DebugOff,

    pub fn shouldStep(self: DebugMode) bool {
        return switch (self) {
            .DebugStep => true,
            .DebugLog => false,
            .DebugOff => false,
        };
    }

    pub fn shouldLog(self: DebugMode) bool {
        return switch (self) {
            .DebugStep => true,
            .DebugLog => true,
            .DebugOff => false,
        };
    }

    pub fn shouldShowDebugWindow(self: DebugMode) bool {
        return switch (self) {
            .DebugStep => true,
            .DebugLog => true,
            .DebugOff => false,
        };
    }
};

pub fn waitForEnter() void {
    _ = c.getchar();
}

pub fn getSerialDebugOutput(serial: *Serial) ?[]const u8 {
    if (serial.receiveByte()) {
        const serial_output = serial.bytes_received[0..serial.bytes_received_length];
        if (std.mem.count(u8, serial_output, "Passed") > 0 or std.mem.count(u8, serial_output, "Failed") > 0) {
            return serial_output;
        }
    }

    return null;
}

pub fn getCurrentInstruction(cpu: *Cpu) u16 {
    const op = cpu.mmu.readByte(cpu.pc);
    if (op == 0xCB) {
        const op_cb = cpu.mmu.readByte(cpu.pc + 1);
        return 0xCB00 | @as(u16, op_cb);
    }

    return op;
}

pub fn getCurrentInstructionName(cpu: *Cpu) []const u8 {
    const op = cpu.mmu.readByte(cpu.pc);
    if (op == 0xCB) {
        const op_cb = cpu.mmu.readByte(cpu.pc + 1);
        return opcodes_cb_names[op_cb];
    }

    return opcode_names[op];
}
