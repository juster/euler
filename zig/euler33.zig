const std = @import("std");
const print = std.debug.print;
const euclid = @import("euler").euclid;

pub fn main() !void {
    var n: u64 = 49;
    var d: u64 = 98;
    print("{}\n", .{euclid(@TypeOf(n, d), n, d)});
}
