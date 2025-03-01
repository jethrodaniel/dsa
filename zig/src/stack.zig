const std = @import("std");
const testing = std.testing;
const SinglyLinkedList = @import("./singly_linked_list.zig").SinglyLinkedList;

pub fn Stack(comptime T: type) type {
    return struct {
        const Self = @This();

        list: SinglyLinkedList(T),

        pub fn init(allocator: std.mem.Allocator) Self {
            return Self{
                .list = SinglyLinkedList(T).init(allocator),
            };
        }

        pub fn deinit(self: *Self) void {
            self.list.deinit();
            self.* = undefined;
        }

        pub fn push(self: *Self, item: T) !T {
            _ = try self.list.prepend(item);
            return item;
        }

        pub fn peek(self: *Self) !T {
            if (self.list.is_empty()) {
                return error.EmptyStack;
            }
            const node = try self.list.get(0);
            return node.value;
        }

        pub fn pop(self: *Self) !T {
            if (self.list.is_empty()) {
                return error.EmptyStack;
            }
            const node = try self.list.get(0);
            const item = node.value;

            try self.list.delete(node);

            return item;
        }

        pub fn is_empty(self: *Self) bool {
            return self.list.is_empty();
        }
    };
}

test {
    testing.refAllDecls(@This());
}

test "init/deinit" {
    var stack = Stack(i32).init(testing.allocator);
    defer stack.deinit();
}

test "push" {
    var stack = Stack(i32).init(testing.allocator);
    defer stack.deinit();

    const item = try stack.push(42);
    try testing.expectEqual(@as(i32, 42), item);
}

test "peek" {
    var stack = Stack(i32).init(testing.allocator);
    defer stack.deinit();

    _ = try stack.push(42);

    try testing.expectEqual(@as(i32, 42), try stack.peek());
}

test "pop" {
    var stack = Stack(i32).init(testing.allocator);
    defer stack.deinit();

    _ = try stack.push(42);
    const item = try stack.pop();

    try testing.expectEqual(@as(i32, 42), item);
}

test "is_empty" {
    var stack = Stack(i32).init(testing.allocator);
    defer stack.deinit();

    try testing.expectEqual(true, stack.is_empty());

    _ = try stack.push(42);

    try testing.expectEqual(false, stack.is_empty());
}
