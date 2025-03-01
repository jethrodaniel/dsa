const std = @import("std");
const testing = std.testing;

/// Sort an array using insertion sort.
///
/// ```
/// // initial unsorted array
/// [1, 5, 4, 2, 3]
///
/// // starting from the second to the left, move each item into the leftmost
/// // sorted subarray
///
/// // 5
/// [1, 5, 4, 2, 3]
///
/// // 4
/// [1, 4, 5, 2, 3]
///
/// // 3
/// [1, 2, 4, 5, 3]
///
/// // 2
/// [1, 2, 3, 4, 5]
/// ```
///
/// - Time: O(n ** 2)
/// - Space: O(1)
///
pub fn insertion_sort(comptime T: type, array: []T) void {
    if (array.len <= 1) {
        return;
    }

    for (1..array.len) |index| {
        const current = array[index];

        var j = index;

        while (j > 0 and current < array[j - 1]) {
            array[j] = array[j - 1];
            j -= 1;
        }

        array[j] = current;
    }
}

test {
    testing.refAllDecls(@This());
}

test "empty" {
    var array = [_]u32{};
    insertion_sort(u32, &array);
}

test "single " {
    var array = [_]u32{42};
    insertion_sort(u32, &array);
}

test "worst-case, reversed" {
    var array = [_]u32{ 5, 4, 3, 2, 1 };
    insertion_sort(u32, &array);

    try testing.expectEqual(1, array[0]);
    try testing.expectEqual(2, array[1]);
    try testing.expectEqual(3, array[2]);
    try testing.expectEqual(4, array[3]);
    try testing.expectEqual(5, array[4]);
}

test "best-case, sorted" {
    var array = [_]u32{ 5, 4, 3, 2, 1 };
    insertion_sort(u32, &array);

    try testing.expectEqual(1, array[0]);
    try testing.expectEqual(2, array[1]);
    try testing.expectEqual(3, array[2]);
    try testing.expectEqual(4, array[3]);
    try testing.expectEqual(5, array[4]);
}

test "random" {
    var array = [_]u32{ 1, 5, 4, 2, 3 };
    insertion_sort(u32, &array);

    try testing.expectEqual(1, array[0]);
    try testing.expectEqual(2, array[1]);
    try testing.expectEqual(3, array[2]);
    try testing.expectEqual(4, array[3]);
    try testing.expectEqual(5, array[4]);
}
