const std = @import("std");
const Mmu = @import("mmu/mmu.zig").Mmu;
const memory = @import("mmu/memory/memory.zig");
const Cartridge = @import("cartridge/cartridge.zig").Cartridge;
const Cpu = @import("cpu/cpu.zig").Cpu;
const CycleManager = @import("cycles/cycles.zig").CycleManager;
const GameBoy = @import("gameboy/gameboy.zig").GameBoy;
const interrupts = @import("io/interrupts/interrupts.zig");
const Serial = @import("io/serial/serial.zig").Serial;
const Timer = @import("io/timer/timer.zig").Timer;
const Io = @import("io/io.zig").Io;
const files = @import("utils/files/files.zig");
const errors = @import("errors/errors.zig");
const Ui = @import("ui/ui.zig").Ui;

const logger = std.log.scoped(.main);

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
    var serial = Serial.init();
    var timer = Timer.init(&interrupt_registers);
    var io = Io.init(&serial, &timer, &interrupt_registers);

    var cart = Cartridge.init(file_bytes.bytes);

    var wram = memory.WRam.init();
    var hram = memory.HRam.init();
    var mmu = Mmu.init(&cart, &wram, &hram, &io);

    var cycle_manager = CycleManager.init(&timer);
    var cpu = Cpu.init(&mmu, &cycle_manager, &io);

    const start = std.time.timestamp();
    var gameboy = GameBoy.init(&cpu);
    const thread = try std.Thread.spawn(.{ .allocator = allocator }, GameBoy.start, .{&gameboy});

    var ui = try Ui.init(allocator);
    defer ui.deinit();

    _ = try ui.createGameBoyWindow("GameBoy", &gameboy);
    ui.run();

    gameboy.stop();
    thread.join();

    const end = std.time.timestamp();
    logger.info("Gameboy ran for {d} seconds", .{end - start});
}
