//timer div increment frequency = 16,384 Hz
//ticks per timer div increment = 4,194,304Hz / 16,384Hz = 256 ticks/div
//cycles per timer div increment = 1,048,576Hz / 16,384Hz = 64 cycles/div
const InterruptRegisters = @import("../interrupts/interrupts.zig").InterruptRegisters;
const Interrupt = @import("../interrupts/interrupts.zig").Interrupt;

pub const Timer = struct {
    div: u16,
    tima: u8,
    tma: u8,
    tac: u8,
    interrupt_registers: *InterruptRegisters,

    pub fn init(interrupt_registers: *InterruptRegisters) Timer {
        return .{
            .div = 0xABCC,
            .tima = 0,
            .tma = 0,
            .tac = 0,
            .interrupt_registers = interrupt_registers,
        };
    }

    pub fn readByte(self: *const Timer, address: u16) u8 {
        return switch (address) {
            0xFF04 => @truncate(self.div >> 8),
            0xFF05 => self.tima,
            0xFF06 => self.tma,
            0xFF07 => self.tac,
            else => @panic("invalid timer address"),
        };
    }

    pub fn writeByte(self: *Timer, address: u16, value: u8) void {
        switch (address) {
            0xFF04 => self.div = 0,
            0xFF05 => self.tima = value,
            0xFF06 => self.tma = value,
            0xFF07 => self.tac = value,
            else => @panic("invalid timer address"),
        }
    }

    pub fn getTimerEnable(self: *const Timer) u1 {
        return @intFromBool(self.tac & 0x04 != 0);
    }

    pub fn getClockSelect(self: *const Timer) u2 {
        return @truncate(self.tac & 0x03);
    }

    pub fn getBitPositionFromClockSelect(self: *const Timer) u4 {
        return switch (self.getClockSelect()) {
            0b00 => 9,
            0b01 => 3,
            0b10 => 5,
            0b11 => 7,
        };
    }

    pub fn getBitFromDiv(self: *const Timer, position: u4) u1 {
        return @intFromBool(self.div & (@as(u16, 0x0001) << position) != 0);
    }

    pub fn tick(self: *Timer) void {
        const timer_enable = self.getTimerEnable();
        const bit_position = self.getBitPositionFromClockSelect();

        //todo edge case, use previous timer enable??
        const prev_result = self.getBitFromDiv(bit_position) & timer_enable;
        self.div +%= 1;
        const cur_result = self.getBitFromDiv(bit_position) & timer_enable;

        if (prev_result == 1 and cur_result == 0) {
            if (self.tima == 0xFF) {
                // todo 4 tick delay??
                self.tima = self.tma;
                self.interrupt_registers.setSpecifiedInterruptFlag(Interrupt.Timer, true);
            } else {
                self.tima += 1;
            }
        }
    }
};
