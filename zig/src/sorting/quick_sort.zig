const std = @import("std");
const testing = std.testing;

// swap array[a] with array[b]
fn swap(comptime T: type, array: []T, a: usize, b: usize) void {
    const temp = array[a];
    array[a] = array[b];
    array[b] = temp;
}

// modify the array such that items less than array[pivot] are to the left of
// the pivot, and items greater than the pivot are to the right of the pivot
fn partition(comptime T: type, array: []T, lower: usize, pivot: usize, upper: usize) usize {
    const pivot_value = array[pivot];

    // place the pivot at the beginning
    swap(T, array, lower, pivot);

    var left: usize = lower + 1;
    var right: usize = upper;

    while (left <= right) {
        if (array[left] <= pivot_value) {
            left += 1;
        } else {
            swap(T, array, left, right);
            right -= 1;
        }
    }

    // move the pivot to the middle
    swap(T, array, lower, left - 1);

    return left - 1;
}

fn quick_sort_from(comptime T: type, array: []T, lower: usize, upper: usize) void {
    // ensure we have at least 2 elements to sort
    if (lower >= upper) {
        return;
    }

    const rand = std.crypto.random;
    const pivot: usize = rand.intRangeAtMost(usize, lower, upper);

    const middle = partition(T, array, lower, pivot, upper);

    quick_sort_from(T, array, lower, middle);
    quick_sort_from(T, array, middle + 1, upper);
}

/// Sort an array in-place using quick sort.
///
/// - Time
///   - Average: O(n log n)
///   - Worst: O(n ** 2)
/// - Space:
///   - Average: O(log n)
///   - Worst: O(n)
///
pub fn quick_sort(comptime T: type, array: []T, length: usize) void {
    if (length <= 1) {
        return;
    }

    quick_sort_from(T, array, 0, length - 1);
}

test {
    testing.refAllDecls(@This());
}

test "empty" {
    var array = [_]u32{};
    quick_sort(u32, &array, array.len);
}

test "single" {
    var array = [_]u32{42};
    quick_sort(u32, &array, array.len);
}

test "reversed" {
    var array = [_]u32{ 5, 4, 3, 2, 1 };
    quick_sort(u32, &array, array.len);

    try testing.expectEqual(1, array[0]);
    try testing.expectEqual(2, array[1]);
    try testing.expectEqual(3, array[2]);
    try testing.expectEqual(4, array[3]);
    try testing.expectEqual(5, array[4]);
}

test "sorted" {
    var array = [_]u32{ 1, 2, 3, 4, 5 };
    quick_sort(u32, &array, array.len);

    try testing.expectEqual(1, array[0]);
    try testing.expectEqual(2, array[1]);
    try testing.expectEqual(3, array[2]);
    try testing.expectEqual(4, array[3]);
    try testing.expectEqual(5, array[4]);
}

test "random" {
    var array = [_]u32{ 1, 5, 4, 2, 3 };
    quick_sort(u32, &array, array.len);

    try testing.expectEqual(1, array[0]);
    try testing.expectEqual(2, array[1]);
    try testing.expectEqual(3, array[2]);
    try testing.expectEqual(4, array[3]);
    try testing.expectEqual(5, array[4]);
}
