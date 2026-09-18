pub fn Queue(comptime T: type, comptime SIZE: usize) type {
    return struct {
        const Self = @This();

        items: [SIZE]T,
        head: usize,
        tail: usize,
        count: usize,

        pub fn init() Self {
            return .{
                .items = undefined,
                .head = 0,
                .tail = 0,
                .count = 0,
            };
        }

        pub fn enqueue(self: *Self, item: T) void {
            if (self.isFull()) {
                return;
            }

            self.items[self.tail] = item;
            self.tail = if (self.tail + 1 >= SIZE) 0 else self.tail + 1;
            self.count += 1;
        }

        pub fn dequeue(self: *Self) ?T {
            if (self.isEmpty()) {
                return null;
            }

            const item = self.items[self.head];
            self.head = if (self.head + 1 >= SIZE) 0 else self.head + 1;
            self.count -= 1;
            return item;
        }

        pub fn isFull(self: *const Self) bool {
            return self.count == SIZE;
        }

        pub fn isEmpty(self: *const Self) bool {
            return self.count == 0;
        }

        pub fn clear(self: *Self) void {
            self.head = 0;
            self.tail = 0;
            self.count = 0;
        }
    };
}
