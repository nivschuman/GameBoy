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

    pub fn readSignedByte(self: *const Memory, address: u16) i8 {
        return @bitCast(self.data[address]);
    }

    pub fn writeByte(self: *Memory, address: u16, value: u8) void {
        self.data[address] = value;
    }

    pub fn readWord(self: *const Memory, address: u16) u16 {
        const low = readByte(self, address);
        const high = readByte(self, address + 1);
        return (@as(u16, high) << 8) | (@as(u16, low));
    }

    pub fn writeWord(self: *Memory, address: u16, value: u16) void {
        const low = @as(u8, @truncate(value));
        const high = @as(u8, @truncate(value >> 8));
        self.data[address] = low;
        self.data[address + 1] = high;
    }
};
