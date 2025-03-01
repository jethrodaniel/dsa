const std = @import("std");
const testing = std.testing;

// merge 2 sorted sub-arrays
//
fn merge(comptime T: type, array: []T, comptime left: usize, comptime middle: usize, comptime right: usize) void {
    const length_left = middle - left + 1;
    const length_right = right - middle;

    // create copies of the left and right arrays in-memory
    //
    // left: array[0 .. middle]
    // right: array[middle + 1 .. right]
    //
    var left_array = [_]T{0} ** length_left;
    var right_array = [_]T{0} ** length_right;
    {
        var index: usize = 0;
        while (index < length_left) : (index += 1) {
            left_array[index] = array[left + index];
        }

        index = 0;
        while (index < length_right) : (index += 1) {
            right_array[index] = array[middle + 1 + index];
        }
    }

    var left_index: usize = 0;
    var right_index: usize = 0;
    var array_index: usize = left;

    // scan through the left and right arrays, inserting the smaller of either
    // into the correct position in the main array
    //
    while (left_index < length_left and right_index < length_right) {
        if (left_array[left_index] <= right_array[right_index]) {
            array[array_index] = left_array[left_index];
            left_index += 1;
        } else {
            array[array_index] = right_array[right_index];
            right_index += 1;
        }
        array_index += 1;
    }

    // insert the remainder of left array into the main array
    while (left_index < length_left) {
        array[array_index] = left_array[left_index];
        left_index += 1;
        array_index += 1;
    }

    // insert the remainder of right array into the main array
    while (right_index < length_right) {
        array[array_index] = right_array[right_index];
        right_index += 1;
        array_index += 1;
    }
}

// sort the subarray from array[left .. right]
//
fn merge_sort_from(comptime T: type, array: []T, comptime left: usize, comptime right: usize) void {
    if (left < right) {
        const middle = left + (right - left) / 2;

        // divide the problem into 2, sort each half
        merge_sort_from(T, array, left, middle);
        merge_sort_from(T, array, middle + 1, right);

        // merge the sorted sub-arrays
        return merge(T, array, left, middle, right);
    }
}

/// Sort an array using merge sort.
///
/// ```
/// // initial unsorted array
/// [1, 5, 4, 2, 3]
///
/// // divide in 2, sort the left half first
/// // keep dividing until each subarray is of size 1
/// [1, 5, 4] [2, 3]
/// [1] [5, 4] [2, 3]
/// [1] [5] [4] [2, 3]
///
/// // combine the subarrays
/// [1] [4, 5] [2, 3]
/// [1, 4, 5] [2, 3]
///
/// // repeat with the right half
/// [1, 4, 5] [2] [3]
/// [1, 4, 5] [2, 3]
///
/// // merge both sorted subarrays
/// [1, 2, 3, 4, 5]
/// ```
///
/// - Time: O(n log n)
/// - Space: O(n)
///
pub fn merge_sort(comptime T: type, array: []T, comptime length: usize) void {
    if (length <= 1) {
        return;
    }

    merge_sort_from(T, array, 0, length - 1);
}

test {
    testing.refAllDecls(@This());
}

test "merge_sort" {
    var empty = [_]u32{};
    merge_sort(u32, &empty, empty.len);

    var single = [_]u32{42};
    merge_sort(u32, &single, single.len);

    var array = [_]u32{ 1, 5, 4, 2, 3 };
    merge_sort(u32, &array, array.len);

    try testing.expectEqual(1, array[0]);
    try testing.expectEqual(2, array[1]);
    try testing.expectEqual(3, array[2]);
    try testing.expectEqual(4, array[3]);
    try testing.expectEqual(5, array[4]);
}
