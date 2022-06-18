const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
    var fac: [10]u64 = .{1} ++ (.{0} ** 9);
    var i: usize = 1;
    while (i < fac.len) : (i += 1) fac[i] = fac[i-1] * i;
    print("{d}\n", .{fac});

    const max = 5;
    var d: [max]u8 = .{0} ** max;
    var n: usize = 1;

    d[0] = 3;
    while (true) {
        var a: u64 = 0;
        var c: u64 = 1;
        var facsum: u64 = 0;
        for (d[0..n]) |b| {
            facsum += fac[b];
            a += b * c;
            c *= 10;
        }
        // print("{} {}\n", .{a, facsum});
        if (a == facsum) print("{}\n", .{a});

        d[0] += 1;
        if (carry(&d, n)) |m| n = m else break;
    }
}

fn carry(buf: []u8, count: usize) ?usize {
    var n = count;
    var j: usize = 0;
    while (j < n) : (j += 1) {
        if (buf[j] < 10) break;
        if (j == buf.len-1) return null;
        buf[j+1] += buf[j] / 10;
        buf[j+0] %= 10;
        if (j == n-1) n += 1;
    }
    return n;
}
