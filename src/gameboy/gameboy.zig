const Cpu = @import("../cpu/cpu.zig").Cpu;
const std = @import("std");

pub const GameBoy = struct {
    cpu: *Cpu,
    run: std.atomic.Value(bool),

    pub fn init(cpu: *Cpu) GameBoy {
        return .{
            .cpu = cpu,
            .run = std.atomic.Value(bool).init(false),
        };
    }

    pub fn start(self: *GameBoy) void {
        self.run.store(true, std.builtin.AtomicOrder.seq_cst);
        while (self.run.load(std.builtin.AtomicOrder.seq_cst)) {
            self.cpu.step();
        }
    }

    pub fn stop(self: *GameBoy) void {
        self.run.store(false, std.builtin.AtomicOrder.seq_cst);
    }
};
