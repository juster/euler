const std = @import("std");
const print = std.debug.print;
const fmt = std.fmt;
const math = std.math;

pub fn main() !void {
    const max = 1e6;
    const n = comptime @floatToInt(u64, math.ceil(math.log2(max)));
    var i: u64 = 1;
    var sum: u64 = 0;
    var buf: [n]u8 = undefined;
    while (i < max) : (i += 1) {
        const str1 = try fmt.bufPrint(buf[0..], "{d}", .{i});
        if (!palindrome(str1)) continue;
        const str2 = try fmt.bufPrint(buf[0..], "{b}", .{i});
        if (!palindrome(str2)) continue;

        print("{d}\n", .{i});
        sum += i;
    }

    print("\n{d}\n", .{sum});
}

fn palindrome(buf: []u8) bool {
    var i: usize = 0;
    var j: usize = buf.len - 1;
    while (i < j) {
        if (buf[i] != buf[j]) return false;
        i += 1;
        j -= 1;
    }
    return true;
}
