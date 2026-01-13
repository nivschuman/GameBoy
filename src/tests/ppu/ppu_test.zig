const std = @import("std");
const Mmu = @import("../../mmu/mmu.zig").Mmu;
const memory = @import("../../mmu/memory/memory.zig");
const Cartridge = @import("../../cartridge/cartridge.zig").Cartridge;
const Cpu = @import("../../cpu/cpu.zig").Cpu;
const CycleManager = @import("../../cycles/cycles.zig").CycleManager;
const interrupts = @import("../../io/interrupts/interrupts.zig");
const Serial = @import("../../io/serial/serial.zig").Serial;
const Timer = @import("../../io/timer/timer.zig").Timer;
const Io = @import("../../io/io.zig").Io;
const Oam = @import("../../ppu/oam/oam.zig").Oam;
const VRam = @import("../../ppu/vram/vram.zig").VRam;
const Dma = @import("../../io/lcd/dma/dma.zig").Dma;
const Lcd = @import("../../io/lcd/lcd.zig").Lcd;
const Ppu = @import("../../ppu/ppu.zig").Ppu;
const StdStopwatch = @import("../../utils/time/time.zig").StdStopwatch;
const StdDelayer = @import("../../utils/time/time.zig").StdDelayer;

pub fn testWithPpu(testFunction: fn (*Ppu) anyerror!void) anyerror!void {
    var interrupt_registers = interrupts.InterruptRegisters.init();
    var dma = Dma.init();
    var lcd = Lcd.init(&dma);
    var vram = VRam.init();
    var oam = Oam.init();
    var ppu = Ppu.init(&oam, &vram, &dma, &lcd, &interrupt_registers, StdStopwatch.init(), StdDelayer.init());
    try testFunction(&ppu);
}

test "VBLANK mode" {
    const testFunction = struct {
        pub fn testFunction(ppu: *Ppu) anyerror!void {
            ppu.lcd.ly = Ppu.VERTICAL_HEIGHT - 1;
            ppu.lcd.setLcdMode(.HBLANK);
            ppu.ticks = Ppu.TICKS_PER_LINE;

            ppu.tick();
            try std.testing.expect(ppu.lcd.getLcdMode() == .VBLANK);
            try std.testing.expect(ppu.interrupt_registers.getSpecifiedInterruptFlag(.VBlank));
        }
    }.testFunction;
    try testWithPpu(testFunction);
}

test "HBLANK mode" {
    const testFunction = struct {
        pub fn testFunction(ppu: *Ppu) anyerror!void {
            ppu.lcd.lyc = 1;
            ppu.lcd.ly = 0;
            ppu.lcd.setLcdMode(.HBLANK);
            ppu.lcd.setStatInterruptCondition(.VBLANK, true);
            ppu.lcd.setStatInterruptCondition(.LYC, true);
            ppu.ticks = Ppu.TICKS_PER_LINE;

            ppu.tick();
            try std.testing.expect(ppu.lcd.getLcdMode() == .OAM_SEARCH);
            try std.testing.expect(ppu.interrupt_registers.getSpecifiedInterruptFlag(.LCD));
            try std.testing.expect(!ppu.interrupt_registers.getSpecifiedInterruptFlag(.VBlank));
        }
    }.testFunction;
    try testWithPpu(testFunction);
}
