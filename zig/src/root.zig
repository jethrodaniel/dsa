const std = @import("std");

pub const SinglyLinkedList = @import("./singly_linked_list.zig");

test {
    std.testing.refAllDecls(@This());
}
