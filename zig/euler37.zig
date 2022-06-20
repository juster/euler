const std = @import("std");
const fmt = std.fmt;
const euler = @import("euler");
const print = std.debug.print;

pub fn main() !void {
    var prime: [1e6]bool = undefined;
    euler.primesieve(&prime);

    var l: u64 = 0;
    var c: u64 = 0;
    while (l < prime.len) : (l += 1) {
        if (prime[l]) c += 1;
    }
    print("{} primes\n", .{c});

    var buf: [20]u8 = undefined;
    var i: u64 = 8;
    var sum: u64 = 0;
    ILOOP: while (i < 1e6) : (i += 1) {
        if (!prime[i])
            continue;

        const str = try fmt.bufPrint(&buf, "{d}", .{i});
        var j: usize = 1;
        while (j < str.len) : (j += 1) {
            if (!prime[try fmt.parseInt(u64, str[j..str.len], 10)])
                continue :ILOOP;
        }

        var k: usize = str.len - 1;
        while (k > 0) : (k -= 1) {
            if (!prime[try fmt.parseInt(u64, str[0..k], 10)])
                continue :ILOOP;
        }

        print("{}\n", .{i});
        sum += i;
    }

    print("sum: {}\n", .{sum});
}
