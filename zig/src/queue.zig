const std = @import("std");
const testing = std.testing;
const SinglyLinkedList = @import("./singly_linked_list.zig").SinglyLinkedList;
const Node = @import("./singly_linked_list.zig").Node;

/// A queue, implemented using a singly linked list.
///
pub fn Queue(comptime T: type) type {
    return struct {
        const Self = @This();

        list: SinglyLinkedList(T),
        front: ?*Node(T),
        back: ?*Node(T),

        /// Create a new queue.
        ///
        pub fn init(allocator: std.mem.Allocator) Self {
            return Self{
                .list = SinglyLinkedList(T).init(allocator),
                .front = null,
                .back = null,
            };
        }

        /// Release all allocated memory.
        ///
        pub fn deinit(self: *Self) void {
            self.list.deinit();
            self.* = undefined;
        }

        ///` Push an item to the back of the queue.
        ///
        pub fn enqueue(self: *Self, item: T) !T {
            if (self.list.is_empty()) {
                const node = try self.list.append(item);
                self.front = node;
                self.back = node;
            } else {
                self.back = try self.list.append(item);
            }

            return item;
        }

        /// Return the front of the queue.
        ///
        pub fn peek(self: *Self) !T {
            if (self.list.is_empty()) {
                return error.EmptyQueue;
            }

            if (self.front) |front| {
                return front.value;
            }

            @panic("self.front is null (this shouldn't happen!)");
        }

        /// Pop an item from the front of the queue.
        ///
        pub fn dequeue(self: *Self) !T {
            const item = try self.peek();

            if (self.front) |front| {
                self.front = front.next;
                try self.list.delete(front);

                return item;
            }

            @panic("self.front is null (this shouldn't happen!)");
        }

        /// Check if the queue is empty.
        ///
        pub fn is_empty(self: *Self) bool {
            return self.list.is_empty();
        }
    };
}

test {
    testing.refAllDecls(@This());
}

test "init/deinit" {
    var queue = Queue(i32).init(testing.allocator);
    defer queue.deinit();
}

test "enqueue" {
    var queue = Queue(i32).init(testing.allocator);
    defer queue.deinit();

    const one = try queue.enqueue(1);
    const two = try queue.enqueue(2);

    try testing.expectEqual(@as(i32, 1), one);
    try testing.expectEqual(@as(i32, 2), two);
}

test "peek" {
    var queue = Queue(i32).init(testing.allocator);
    defer queue.deinit();

    _ = try queue.enqueue(1);
    _ = try queue.enqueue(2);

    try testing.expectEqual(@as(i32, 1), try queue.peek());
}

test "dequeue" {
    var queue = Queue(i32).init(testing.allocator);
    defer queue.deinit();

    _ = try queue.enqueue(1);
    _ = try queue.enqueue(2);
    const item = try queue.dequeue();

    try testing.expectEqual(@as(i32, 1), item);
}

test "is_empty" {
    var queue = Queue(i32).init(testing.allocator);
    defer queue.deinit();

    try testing.expectEqual(true, queue.is_empty());

    _ = try queue.enqueue(42);

    try testing.expectEqual(false, queue.is_empty());
}
