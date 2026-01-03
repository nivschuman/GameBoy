pub fn Memory(comptime size: usize) type {
    return struct {
        data: [size]u8,

        pub fn init() @This() {
            return .{ .data = [_]u8{0} ** size };
        }

        pub fn readByte(self: *const @This(), address: u16) u8 {
            return self.data[address];
        }

        pub fn writeByte(self: *@This(), address: u16, value: u8) void {
            self.data[address] = value;
        }
    };
}

pub const WRam = Memory(0x2000);
pub const HRam = Memory(0x80);
pub const VRam = Memory(0x2000);
