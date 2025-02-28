const std = @import("std");
const testing = std.testing;

fn Node(comptime T: type) type {
    return struct {
        value: T,
        next: ?*@This(),
    };
}

pub fn SinglyLinkedList(comptime T: type) type {
    return struct {
        const Self = @This();

        allocator: std.mem.Allocator,
        root: ?*Node(T),

        pub fn init(allocator: std.mem.Allocator) Self {
            return Self{
                .root = null,
                .allocator = allocator,
            };
        }

        pub fn deinit(self: *Self) void {
            if (self.root) |root| {
                var node = root;

                if (node.next == null) {
                    self.allocator.destroy(node);
                } else {
                    while (node.next) |next| {
                        self.allocator.destroy(node);
                        node = next;
                    }
                    self.allocator.destroy(node);
                }
            }

            self.* = undefined;
        }

        pub fn prepend(self: *Self, item: T) !T {
            const node = try self.allocator.create(Node(T));
            node.value = item;
            node.next = self.root;

            self.root = node;

            return item;
        }

        pub fn length(self: *Self) usize {
            var sum: usize = 0;

            if (self.root) |root| {
                var node = root;
                sum += 1;

                while (node.next) |next| {
                    node = next;
                    sum += 1;
                }
            }

            return sum;
        }

        pub fn append(self: *Self, item: T) !T {
            if (self.root) |root| {
                var node = root;
                while (node.next) |next| {
                    node = next;
                }
                const last = try self.allocator.create(Node(T));
                last.value = item;
                last.next = null;

                node.next = last;
            } else {
                const node = try self.allocator.create(Node(T));
                node.value = item;
                node.next = null;

                self.root = node;
            }

            return item;
        }

        pub fn get(self: *Self, index: usize) !*Node(T) {
            if (self.root) |root| {
                var node = root;

                if (index == 0) {
                    return node;
                }

                var current_index: usize = 1;

                while (node.next) |next| {
                    if (current_index == index) {
                        return next;
                    }
                    current_index += 1;
                    node = next;
                }

                if (current_index == index + 1) {
                    return node;
                }

                return error.IndexOutOfBounds;
            }

            return error.EmptyList;
        }
    };
}

test {
    std.testing.refAllDecls(@This());
}

test "init/deinit" {
    var list = SinglyLinkedList(i32).init(std.testing.allocator);
    defer list.deinit();
}

test "prepend" {
    var list = SinglyLinkedList(i32).init(std.testing.allocator);
    defer list.deinit();

    const item = try list.prepend(42);
    try std.testing.expectEqual(@as(i32, 42), item);
}

test "append" {
    var list = SinglyLinkedList(i32).init(std.testing.allocator);
    defer list.deinit();

    const item = try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), item);
}

test "length" {
    var list = SinglyLinkedList(i32).init(std.testing.allocator);
    defer list.deinit();

    try std.testing.expectEqual(@as(usize, 0), list.length());

    _ = try list.prepend(42);
    try std.testing.expectEqual(@as(usize, 1), list.length());

    _ = try list.prepend(42);
    try std.testing.expectEqual(@as(usize, 2), list.length());
}

test "get" {
    var list = SinglyLinkedList(i32).init(std.testing.allocator);
    defer list.deinit();

    try std.testing.expectError(error.EmptyList, list.get(0));

    var node: *Node(i32) = undefined;

    _ = try list.prepend(2);
    _ = try list.prepend(1);
    _ = try list.append(3);

    node = try list.get(0);
    try std.testing.expectEqual(@as(i32, 1), node.value);

    node = try list.get(1);
    try std.testing.expectEqual(@as(i32, 2), node.value);

    node = try list.get(2);
    try std.testing.expectEqual(@as(i32, 3), node.value);

    try std.testing.expectError(error.IndexOutOfBounds, list.get(3));
}

test "delete" {
    var list = SinglyLinkedList(i32).init(std.testing.allocator);
    defer list.deinit();

    // TODO
}

test "insert" {
    var list = SinglyLinkedList(i32).init(std.testing.allocator);
    defer list.deinit();

    // TODO
}

test "include" {
    var list = SinglyLinkedList(i32).init(std.testing.allocator);
    defer list.deinit();

    // TODO
}
