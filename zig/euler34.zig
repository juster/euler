const std = @import("std");
const print = std.debug.print;
const fmt = std.fmt;

pub fn main() !void {
    const max = 5;
    var fac: [10]u64 = .{1} ++ (.{0} ** 9);

    var i: u64 = 1;
    while (i < fac.len) : (i += 1) fac[i] = fac[i-1] * i;
    // print("{d}\n", .{fac});

    var d: [max]u8 = .{0} ** max;

    i = 3;
    while (i < 50000) : (i += 1) {
        const n = fmt.formatIntBuf(&d, i, 10, fmt.Case.lower, .{});
        var facsum: u64 = 0;
        for (d[0..n]) |b| facsum += fac[b-'0'];
        // print("{} {}\n", .{a, facsum});
        if (i == facsum) print("{}\n", .{i});
    }
}
