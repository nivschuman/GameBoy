// 1 frame = 70224 ticks, a frame is the entire screen drawn (160x144 pixels)
// there are 154 lines per frame (0-143 on screen lines, 144-153 off screen lines)
// 70224 / 154 = 456 ticks per line

const VRam = @import("vram/vram.zig").VRam;
const Oam = @import("oam/oam.zig").Oam;
const Dma = @import("../io/lcd/dma/dma.zig").Dma;
const Lcd = @import("../io/lcd/lcd.zig").Lcd;
const InterruptRegisters = @import("../io/interrupts/interrupts.zig").InterruptRegisters;
const Tick = @import("../cycles/cycles.zig").Tick;
const Stopwatch = @import("../utils/time/time.zig").Stopwatch;
const Delayer = @import("../utils/time/time.zig").Delayer;

pub const Ppu = struct {
    const TICKS_PER_OAM_SEARCH_MODE: Tick = 80;
    const TICKS_PER_PIXEL_TRANSFER_MODE: Tick = 172;
    const TICKS_PER_LINE: Tick = 456;
    const VERTICAL_HEIGHT: u8 = 144;
    const LINES_PER_FRAME: u8 = 154;
    const EXPECTED_FRAME_TIME: u32 = 1000 / 60;

    oam: *Oam,
    vram: *VRam,
    dma: *Dma,
    lcd: *Lcd,
    interrupt_registers: *InterruptRegisters,
    stopwatch: Stopwatch,
    delayer: Delayer,
    ticks: Tick,
    current_frame: u32,

    pub fn init(oam: *Oam, vram: *VRam, dma: *Dma, lcd: *Lcd, interrupt_registers: *InterruptRegisters, stopwatch: Stopwatch, delayer: Delayer) Ppu {
        return .{
            .oam = oam,
            .vram = vram,
            .dma = dma,
            .lcd = lcd,
            .interrupt_registers = interrupt_registers,
            .stopwatch = stopwatch,
            .delayer = delayer,
            .ticks = 0,
            .current_frame = 0,
        };
    }

    pub fn readByte(self: *const Ppu, address: u16) u8 {
        return switch (address) {
            0x8000...0x9FFF => self.vram.readByte(address),
            0xFE00...0xFE9F => if (self.dma.transferring()) 0xFF else self.oam.readByte(address - 0xFE00),
            else => @panic("invalid ppu address"),
        };
    }

    pub fn writeByte(self: *Ppu, address: u16, value: u8) void {
        switch (address) {
            0x8000...0x9FFF => self.vram.writeByte(address, value),
            0xFE00...0xFE9F => if (!self.dma.transferring()) self.oam.writeByte(address - 0xFE00, value),
            else => @panic("invalid ppu address"),
        }
    }

    pub fn tick(self: *Ppu) void {
        self.ticks += 1;
        switch (self.lcd.getLcdMode()) {
            .HBLANK => self.hBlankMode(),
            .VBLANK => self.vBlankMode(),
            .OAM_SEARCH => self.oamSearchMode(),
            .PIXEL_TRANSFER => self.pixelTransferMode(),
        }
    }

    fn oamSearchMode(self: *Ppu) void {
        if (self.ticks >= TICKS_PER_OAM_SEARCH_MODE) {
            self.lcd.setLcdMode(.PIXEL_TRANSFER);
        }
    }

    fn hBlankMode(self: *Ppu) void {
        if (self.ticks < TICKS_PER_LINE) {
            return;
        }

        self.incrementLy();
        if (self.lcd.ly >= VERTICAL_HEIGHT) {
            self.lcd.setLcdMode(.VBLANK);
            self.interrupt_registers.setSpecifiedInterruptFlag(.VBlank, true);
            if (self.lcd.getStatInterruptCondition(.VBLANK)) {
                self.interrupt_registers.setSpecifiedInterruptFlag(.LCD, true);
            }
            self.incrementFrame();
        } else {
            self.lcd.setLcdMode(.OAM_SEARCH);
        }

        self.ticks = 0;
    }

    fn vBlankMode(self: *Ppu) void {
        if (self.ticks < TICKS_PER_LINE) {
            return;
        }

        self.incrementLy();
        if (self.lcd.ly >= LINES_PER_FRAME) {
            self.lcd.setLcdMode(.OAM_SEARCH);
            self.lcd.ly = 0;
        }

        self.ticks = 0;
    }

    fn pixelTransferMode(self: *Ppu) void {
        if (self.ticks >= TICKS_PER_OAM_SEARCH_MODE + TICKS_PER_PIXEL_TRANSFER_MODE) {
            self.lcd.setLcdMode(.HBLANK);
        }
    }

    fn incrementFrame(self: *Ppu) void {
        const frame_time = self.stopwatch.elapsedTime();
        if (frame_time < EXPECTED_FRAME_TIME) {
            self.delayer.delay(EXPECTED_FRAME_TIME - frame_time);
        }

        self.stopwatch.reset();
        self.current_frame +%= 1;
    }

    fn incrementLy(self: *Ppu) void {
        self.lcd.ly += 1;
        self.lcd.setLycEqualsLy(self.lcd.ly == self.lcd.lyc);
        if (self.lcd.ly == self.lcd.lyc and self.lcd.getStatInterruptCondition(.LYC)) {
            self.interrupt_registers.setSpecifiedInterruptFlag(.LCD, true);
        }
    }
};
