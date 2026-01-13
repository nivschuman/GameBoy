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
const Oam = @import("ppu/oam/oam.zig").Oam;
const VRam = @import("ppu/vram/vram.zig").VRam;
const Ppu = @import("ppu/ppu.zig").Ppu;
const files = @import("utils/files/files.zig");
const errors = @import("errors/errors.zig");
const Ui = @import("ui/ui.zig").Ui;
const Icon = @import("ui/ui.zig").Icon;
const debug = @import("gameboy/debug/debug.zig");
const Dma = @import("io/lcd/dma/dma.zig").Dma;
const Lcd = @import("io/lcd/lcd.zig").Lcd;

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
    var dma = Dma.init();
    var lcd = Lcd.init(&dma);
    var io = Io.init(&serial, &timer, &interrupt_registers, &lcd);

    var cart = Cartridge.init(file_bytes.bytes);

    var vram = VRam.init();
    var oam = Oam.init();
    var ppu = Ppu.init(&oam, &vram, &dma);

    var wram = memory.WRam.init();
    var hram = memory.HRam.init();
    var mmu = Mmu.init(&cart, &wram, &hram, &io, &ppu);

    var cycle_manager = CycleManager.init(&timer, &dma, &mmu);
    var cpu = Cpu.init(&mmu, &cycle_manager, &io);

    var debug_mode = debug.DebugMode.DebugOff;
    if (args.len >= 3) {
        if (std.meta.stringToEnum(debug.DebugMode, args[2])) |mode| {
            debug_mode = mode;
        }
    }

    const start = std.time.timestamp();
    var gameboy = GameBoy.init(&cpu, &ppu, debug_mode);
    const thread = try std.Thread.spawn(.{ .allocator = allocator }, GameBoy.start, .{&gameboy});

    var ui = try Ui.init(allocator);
    defer ui.deinit();

    const icon_image = @embedFile("assets/icon.bmp");
    var icon = Icon.init(icon_image);
    defer icon.deinit();

    _ = try ui.createGameBoyWindow("GameBoy", &icon, &gameboy, false);

    if (debug_mode.shouldShowDebugWindow()) {
        const icon_debug_image = @embedFile("assets/icon-debug.bmp");
        var icon_debug = Icon.init(icon_debug_image);
        defer icon_debug.deinit();

        _ = try ui.createGameBoyWindow("GameBoy Debug", &icon_debug, &gameboy, true);
    }

    ui.run();

    gameboy.stop();
    thread.join();

    const end = std.time.timestamp();
    logger.info("Gameboy ran for {d} seconds", .{end - start});
}
