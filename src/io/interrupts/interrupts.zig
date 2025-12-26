const std = @import("std");

pub const Interrupt = enum {
    VBlank,
    LCD,
    Timer,
    Serial,
    Joypad,

    pub fn getPosition(self: Interrupt) u8 {
        return switch (self) {
            .VBlank => 1 << 0,
            .LCD => 1 << 1,
            .Timer => 1 << 2,
            .Serial => 1 << 3,
            .Joypad => 1 << 4,
        };
    }

    pub fn getAddress(self: Interrupt) u16 {
        return switch (self) {
            .VBlank => 0x0040,
            .LCD => 0x0048,
            .Timer => 0x0050,
            .Serial => 0x0058,
            .Joypad => 0x0060,
        };
    }
};

pub const InterruptRegisters = struct {
    interrupt_enable: u8,
    interrupt_flag: u8,

    pub fn init() InterruptRegisters {
        return .{
            .interrupt_enable = 0,
            .interrupt_flag = 0,
        };
    }

    pub fn setInterruptEnable(self: *InterruptRegisters, value: u8) void {
        self.interrupt_enable = value;
    }

    pub fn setInterruptFlag(self: *InterruptRegisters, value: u8) void {
        self.interrupt_flag = value;
    }

    pub fn setSpecifiedInterruptEnable(self: *InterruptRegisters, interrupt: Interrupt, value: bool) void {
        if (value) {
            self.interrupt_enable |= interrupt.getPosition();
        } else {
            self.interrupt_enable &= ~interrupt.getPosition();
        }
    }

    pub fn getSpecifiedInterruptEnable(self: *InterruptRegisters, interrupt: Interrupt) bool {
        return self.interrupt_enable & interrupt.getPosition() != 0;
    }

    pub fn setSpecifiedInterruptFlag(self: *InterruptRegisters, interrupt: Interrupt, value: bool) void {
        if (value) {
            self.interrupt_flag |= interrupt.getPosition();
        } else {
            self.interrupt_flag &= ~interrupt.getPosition();
        }
    }

    pub fn getSpecifiedInterruptFlag(self: *InterruptRegisters, interrupt: Interrupt) bool {
        return self.interrupt_flag & interrupt.getPosition() != 0;
    }

    pub fn getInterruptToHandle(self: *const InterruptRegisters) ?Interrupt {
        const interrupts = std.enums.values(Interrupt);
        for (interrupts) |interrupt| {
            if (self.interrupt_enable & interrupt.getPosition() != 0 and self.interrupt_flag & interrupt.getPosition() != 0) {
                return interrupt;
            }
        }

        return null;
    }
};
