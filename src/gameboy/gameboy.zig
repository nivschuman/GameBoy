const Cpu = @import("../cpu/cpu.zig").Cpu;
const std = @import("std");

const logger = std.log.scoped(.gameboy);

pub const GameBoy = struct {
    cpu: *Cpu,
    run: std.atomic.Value(bool),
    debug: bool,

    pub fn init(cpu: *Cpu, debug: bool) GameBoy {
        return .{
            .cpu = cpu,
            .run = std.atomic.Value(bool).init(false),
            .debug = debug,
        };
    }

    pub fn start(self: *GameBoy) void {
        self.run.store(true, std.builtin.AtomicOrder.seq_cst);
        while (self.run.load(std.builtin.AtomicOrder.seq_cst)) {
            self.cpu.step();
            if (self.debug and self.cpu.io.serial.receiveByte()) {
                const serial_output = self.cpu.io.serial.bytes_received[0..self.cpu.io.serial.bytes_received_length];
                if (std.mem.count(u8, serial_output, "Passed") > 0 or std.mem.count(u8, serial_output, "Failed") > 0) {
                    logger.debug("{s}", .{serial_output});
                }
            }
        }
    }

    pub fn stop(self: *GameBoy) void {
        self.run.store(false, std.builtin.AtomicOrder.seq_cst);
    }
};
