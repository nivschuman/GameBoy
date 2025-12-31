const InterruptRegisters = @import("interrupts/interrupts.zig").InterruptRegisters;
const Serial = @import("serial/serial.zig").Serial;
const Timer = @import("timer/timer.zig").Timer;

pub const Io = struct {
    serial: *Serial,
    timer: *Timer,
    interrupt_registers: *InterruptRegisters,

    pub fn init(serial: *Serial, timer: *Timer, interrupt_registers: *InterruptRegisters) Io {
        return .{
            .serial = serial,
            .timer = timer,
            .interrupt_registers = interrupt_registers,
        };
    }

    pub fn readByte(self: *const Io, address: u16) u8 {
        return switch (address) {
            0xFF01 => self.serial.sb,
            0xFF02 => self.serial.sc,
            0xFF04...0xFF07 => self.timer.readByte(address),
            0xFF0F => self.interrupt_registers.interrupt_flag,
            0xFFFF => self.interrupt_registers.interrupt_enable,
            else => 0,
        };
    }

    pub fn writeByte(self: *Io, address: u16, value: u8) void {
        switch (address) {
            0xFF01 => self.serial.setSB(value),
            0xFF02 => self.serial.setSC(value),
            0xFF04...0xFF07 => self.timer.writeByte(address, value),
            0xFF0F => self.interrupt_registers.setInterruptFlag(value),
            0xFFFF => self.interrupt_registers.setInterruptEnable(value),
            else => {},
        }
    }
};
