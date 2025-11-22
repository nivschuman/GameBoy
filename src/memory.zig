pub const Memory = struct {
    data: [0x10000]u8, // 64 KB

    pub fn init() Memory {
        return .{
            .data = [_]u8{0} ** 0x10000,
        };
    }

    pub fn readByte(self: *const Memory, address: u16) u8 {
        return self.data[address];
    }

    pub fn writeByte(self: *Memory, address: u16, value: u8) void {
        self.data[address] = value;
    }
};
