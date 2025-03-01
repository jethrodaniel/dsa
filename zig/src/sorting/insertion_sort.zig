const std = @import("std");
const testing = std.testing;

/// Sort an array using insertion sort.
///
pub fn insertion_sort(comptime T: type, array: []T) void {
    if (array.len == 0) {
        return;
    }

    for (1..array.len) |i| {
        const current = array[i];

        var j = i - 1;

        while (j > 0 and array[j] > current) : (j -= 1) {
            array[j + 1] = array[j];
        }

        array[j + 1] = current;
    }
}

test {
    testing.refAllDecls(@This());
}

test "insertion_sort" {
    var empty = [_]u32{};
    insertion_sort(u32, &empty);

    var single = [_]u32{42};
    insertion_sort(u32, &single);

    var array = [_]u32{ 1, 5, 4, 2, 3 };

    insertion_sort(u32, &array);

    try testing.expectEqual(1, array[0]);
    try testing.expectEqual(2, array[1]);
    try testing.expectEqual(3, array[2]);
    try testing.expectEqual(4, array[3]);
    try testing.expectEqual(5, array[4]);
}
