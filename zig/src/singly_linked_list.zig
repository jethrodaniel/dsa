const std = @import("std");
const testing = std.testing;

fn Node(comptime T: type) type {
    return struct {
        const Self = @This();

        value: T,
        next: ?*Self,
    };
}

/// A singly linked list.
///
/// Each item in the list contains a value and an optional pointer to the next
/// item in the list.
///
pub fn SinglyLinkedList(comptime T: type) type {
    return struct {
        const Self = @This();

        allocator: std.mem.Allocator,
        root: ?*Node(T),

        /// Create a new list.
        ///
        pub fn init(allocator: std.mem.Allocator) Self {
            return Self{
                .root = null,
                .allocator = allocator,
            };
        }

        /// Release all allocated memory.
        ///
        pub fn deinit(self: *Self) void {
            if (self.root) |root| {
                var node = root;

                while (node.next) |next| {
                    self.allocator.destroy(node);
                    node = next;
                }
                self.allocator.destroy(node);
            }

            self.* = undefined;
        }

        /// Add an item to the beginning of the list.
        ///
        pub fn prepend(self: *Self, item: T) !*Node(T) {
            const node = try self.allocator.create(Node(T));
            node.* = Node(T){ .value = item, .next = self.root };

            self.root = node;

            return node;
        }

        /// Count how many items are in the list.
        ///
        pub fn length(self: *Self) usize {
            var sum: usize = 0;

            if (self.root) |root| {
                var current = root;
                sum += 1;

                while (current.next) |next| {
                    current = next;
                    sum += 1;
                }
            }

            return sum;
        }

        /// Append an item to the end of the list.
        ///
        pub fn append(self: *Self, item: T) !*Node(T) {
            if (self.root) |root| {
                var current = root;
                while (current.next) |next| {
                    current = next;
                }
                const last = try self.allocator.create(Node(T));
                last.* = Node(T){ .value = item, .next = null };

                current.next = last;
                return last;
            }

            const node = try self.allocator.create(Node(T));
            node.* = Node(T){ .value = item, .next = null };

            self.root = node;
            return node;
        }

        /// Get the node at the given index.
        ///
        pub fn get(self: *Self, index: usize) !*Node(T) {
            if (self.root) |root| {
                var current = root;

                if (index == 0) {
                    return current;
                }

                var current_index: usize = 1;

                while (current.next) |next| {
                    if (current_index == index) {
                        return next;
                    }
                    current_index += 1;
                    current = next;
                }

                if (current_index == index + 1) {
                    return current;
                }

                return error.IndexOutOfBounds;
            }

            return error.EmptyList;
        }

        /// Delete a node.
        ///
        pub fn delete(self: *Self, node: *Node(T)) !void {
            if (self.root) |root| {
                if (root == node) {
                    self.root = root.next;
                    self.allocator.destroy(root);
                    return;
                }

                var current = root;

                while (current.next) |next| {
                    if (next == node) {
                        current.next = next.next;
                        self.allocator.destroy(next);
                        return;
                    }
                    current = next;
                }
            }

            return error.NotInList;
        }

        /// Insert an item at the given index.
        ///
        pub fn insert(self: *Self, item: T, index: usize) !*Node(T) {
            if (self.root) |root| {
                if (index == 0) {
                    return self.prepend(item);
                }

                var current = root;
                var current_index: usize = 0;

                while (current.next) |next| {
                    if (current_index + 1 == index) {
                        const node = try self.allocator.create(Node(T));
                        node.* = Node(T){ .value = item, .next = next };

                        current.next = node;

                        return node;
                    }
                    current_index += 1;
                    current = next;
                }

                if (current_index + 1 == index) {
                    const node = try self.allocator.create(Node(T));
                    node.* = Node(T){ .value = item, .next = null };

                    current.next = node;

                    return node;
                }

                return error.IndexOutOfBounds;
            }

            if (index == 0) {
                return self.prepend(item);
            }

            return error.IndexOutOfBounds;
        }

        /// Check if an item exists in the list.
        ///
        pub fn include(self: *Self, item: T) !bool {
            if (self.root) |root| {
                var current = root;
                while (current.next) |next| {
                    if (current.value == item) {
                        return true;
                    }

                    current = next;
                }
                if (current.value == item) {
                    return true;
                }
            }

            return false;
        }

        /// Check if the list is empty.
        ///
        pub fn is_empty(self: *Self) bool {
            return self.root == null;
        }
    };
}

test {
    testing.refAllDecls(@This());
}

test "init/deinit" {
    var list = SinglyLinkedList(i32).init(testing.allocator);
    defer list.deinit();
}

test "prepend" {
    var list = SinglyLinkedList(i32).init(testing.allocator);
    defer list.deinit();

    const node = try list.prepend(42);
    try testing.expectEqual(@as(i32, 42), node.value);
}

test "append" {
    var list = SinglyLinkedList(i32).init(testing.allocator);
    defer list.deinit();

    const node = try list.append(42);
    try testing.expectEqual(@as(i32, 42), node.value);
}

test "length" {
    var list = SinglyLinkedList(i32).init(testing.allocator);
    defer list.deinit();

    try testing.expectEqual(@as(usize, 0), list.length());

    _ = try list.prepend(42);
    try testing.expectEqual(@as(usize, 1), list.length());

    _ = try list.prepend(42);
    try testing.expectEqual(@as(usize, 2), list.length());
}

test "get" {
    var list = SinglyLinkedList(i32).init(testing.allocator);
    defer list.deinit();

    try testing.expectError(error.EmptyList, list.get(0));

    var node: *Node(i32) = undefined;

    _ = try list.prepend(2);
    _ = try list.prepend(1);
    _ = try list.append(3);

    node = try list.get(0);
    try testing.expectEqual(@as(i32, 1), node.value);

    node = try list.get(1);
    try testing.expectEqual(@as(i32, 2), node.value);

    node = try list.get(2);
    try testing.expectEqual(@as(i32, 3), node.value);

    try testing.expectError(error.IndexOutOfBounds, list.get(3));
}

test "delete" {
    var list = SinglyLinkedList(i32).init(testing.allocator);
    defer list.deinit();

    _ = try list.append(1);
    _ = try list.append(2);
    _ = try list.append(3);

    var missing = Node(i32){ .next = null, .value = 42 };
    try testing.expectError(error.NotInList, list.delete(&missing));

    const one = try list.get(0);
    const two = try list.get(1);
    const three = try list.get(2);

    try testing.expectEqual(@as(usize, 3), list.length());

    try list.delete(three);
    try testing.expectEqual(@as(usize, 2), list.length());

    try list.delete(two);
    try testing.expectEqual(@as(usize, 1), list.length());

    try list.delete(one);
    try testing.expectEqual(@as(usize, 0), list.length());
}

test "insert" {
    var list = SinglyLinkedList(i32).init(testing.allocator);
    defer list.deinit();

    var node: *Node(i32) = undefined;

    node = try list.insert(1, 0);
    try testing.expectEqual(@as(i32, 1), node.value);

    node = try list.insert(2, 1);
    try testing.expectEqual(@as(i32, 2), node.value);

    node = try list.insert(3, 2);
    try testing.expectEqual(@as(i32, 3), node.value);

    const one = try list.get(0);
    const two = try list.get(1);
    const three = try list.get(2);

    try testing.expectEqual(@as(i32, 1), one.value);
    try testing.expectEqual(@as(i32, 2), two.value);
    try testing.expectEqual(@as(i32, 3), three.value);

    try testing.expectError(error.IndexOutOfBounds, list.insert(42, 4));
}

test "include" {
    var list = SinglyLinkedList(i32).init(testing.allocator);
    defer list.deinit();

    _ = try list.append(1);
    _ = try list.append(2);
    _ = try list.append(3);

    try testing.expectEqual(true, try list.include(1));
    try testing.expectEqual(true, try list.include(2));
    try testing.expectEqual(true, try list.include(3));
    try testing.expectEqual(false, try list.include(42));
}

test "is_empty" {
    var list = SinglyLinkedList(i32).init(testing.allocator);
    defer list.deinit();

    try testing.expectEqual(true, list.is_empty());

    _ = try list.append(1);

    try testing.expectEqual(false, list.is_empty());
}
