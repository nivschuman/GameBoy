const std = @import("std");
const Mmu = @import("mmu/mmu.zig").Mmu;
const memory = @import("mmu/memory/memory.zig");
const Cartridge = @import("cartridge/cartridge.zig").Cartridge;
const Cpu = @import("cpu/cpu.zig").Cpu;
const CycleManager = @import("cycles/cycles.zig").CycleManager;
const GameBoy = @import("gameboy/gameboy.zig").GameBoy;
const interrupts = @import("cpu/interrupts/interrupts.zig");
const files = @import("utils/files/files.zig");
const errors = @import("errors/errors.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);
    if (args.len < 2) {
        return errors.ArgParseError.MissingArgument;
    }

    const file_loader = files.FileLoader.init(allocator);
    const file_bytes = try file_loader.loadFile(args[1]);
    defer file_bytes.deinit();

    var interrupt_registers = interrupts.InterruptRegisters.init();
    var cart = Cartridge.init(file_bytes.bytes);
    var wram = memory.WRam.init();
    var hram = memory.HRam.init();
    var mmu = Mmu.init(&cart, &wram, &hram, &interrupt_registers);
    var cycle_manager = CycleManager.init();
    var cpu = Cpu.init(&mmu, &cycle_manager, &interrupt_registers);

    var gameboy = GameBoy.init(&cpu);
    gameboy.start();
}
