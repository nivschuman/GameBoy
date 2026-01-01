const Cpu = @import("../cpu/cpu.zig").Cpu;
const std = @import("std");
const debug = @import("debug/debug.zig");

const logger = std.log.scoped(.gameboy);

pub const GameBoy = struct {
    cpu: *Cpu,
    run: std.atomic.Value(bool),
    debug_mode: debug.DebugMode,

    pub fn init(cpu: *Cpu, debug_mode: debug.DebugMode) GameBoy {
        return .{
            .cpu = cpu,
            .run = std.atomic.Value(bool).init(false),
            .debug_mode = debug_mode,
        };
    }

    pub fn start(self: *GameBoy) void {
        self.run.store(true, std.builtin.AtomicOrder.seq_cst);
        while (self.run.load(std.builtin.AtomicOrder.seq_cst)) {
            if (self.debug_mode.shouldStep()) {
                const opcode = debug.getCurrentInstruction(self.cpu);
                const opcode_name = debug.getCurrentInstructionName(self.cpu);
                if (opcode == 0) {
                    logger.debug("[0x{X}] executing opcode 0x{X} {s}", .{ self.cpu.pc, opcode, opcode_name });
                    debug.waitForEnter();
                }
            }

            self.cpu.step();
            if (self.debug_mode.shouldLog()) {
                if (debug.getSerialDebugOutput(self.cpu.io.serial)) |serial_output| {
                    logger.debug("{s}", .{serial_output});
                }
            }
        }
    }

    pub fn stop(self: *GameBoy) void {
        self.run.store(false, std.builtin.AtomicOrder.seq_cst);
    }
};
