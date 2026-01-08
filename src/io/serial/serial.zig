pub const Serial = struct {
    const SIZE: usize = 1024;

    sb: u8,
    sc: u8,
    bytes_received: [SIZE]u8,
    bytes_received_length: usize,

    pub fn init() Serial {
        return .{
            .sb = 0,
            .sc = 0,
            .bytes_received = [_]u8{0} ** SIZE,
            .bytes_received_length = 0,
        };
    }

    pub fn setSB(self: *Serial, value: u8) void {
        self.sb = value;
    }

    pub fn setSC(self: *Serial, value: u8) void {
        self.sc = value;
    }

    pub fn getTransferEnable(self: *const Serial) bool {
        return self.sc & 0x80 != 0;
    }

    pub fn getClockSpeed(self: *const Serial) bool {
        return self.sc & 0x10 != 0;
    }

    pub fn getClockSelect(self: *const Serial) bool {
        return self.sc & 0x01 != 0;
    }

    pub fn receiveByte(self: *Serial) bool {
        if (self.sc == 0x81) {
            if (self.bytes_received_length >= SIZE) {
                self.bytes_received_length = 0;
            }
            self.bytes_received[self.bytes_received_length] = self.sb;
            self.bytes_received_length += 1;
            self.sc = 0;
            return true;
        }

        return false;
    }
};
