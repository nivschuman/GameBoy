const std = @import("std");

pub const FileLoader = struct {
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator) FileLoader {
        return .{ .allocator = allocator };
    }

    pub fn loadFile(self: *const FileLoader, file_path: []const u8) !FileBytes {
        const cwd = std.fs.cwd();
        const file = try cwd.openFile(file_path, .{ .mode = .read_only });
        defer file.close();

        const file_size = try file.getEndPos();
        const file_bytes = try self.allocator.alloc(u8, file_size);
        _ = try file.readAll(file_bytes);

        return .{ .allocator = self.allocator, .bytes = file_bytes };
    }
};

pub const FileBytes = struct {
    allocator: std.mem.Allocator,
    bytes: []u8,

    pub fn init(allocator: std.mem.Allocator, bytes: []u8) FileBytes {
        return .{
            .allocator = allocator,
            .bytes = bytes,
        };
    }

    pub fn deinit(self: *const FileBytes) void {
        self.allocator.free(self.bytes);
    }
};
