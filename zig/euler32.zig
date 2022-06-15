const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    const allocator = arena.allocator();
    defer arena.deinit();

    var found = std.AutoHashMap(u64, void).init(allocator);
    defer found.deinit();

    var digbuf: [9]u8 = .{1,1,0,0,0,0,0,0,0};
    var i  = digbuf[0..2];
    var j  = digbuf[2..5];
    var ij = digbuf[0..5];
    var y  = digbuf[5..];

    while (true) {
        i[0] += 1;
        normalize(i) catch |over| switch (over) {
            error.Overflow => break
        };
        if (!good(i)) continue;

        j[0] = 1; j[1] = 0; j[2] = 1;
        while (true) {
            j[0] += 1;
            normalize(j) catch |over| switch (over) {
                error.Overflow => break
            };
            if (!good(ij)) continue;

            var x = arbToInt(i) * arbToInt(j);
            if (x > 9999) continue;
            if (intToArb(x, y) < 4) continue;
            if (!good(digbuf[0..])) continue;

            print("{} x {} = {}\n",
                  .{arbToInt(i), arbToInt(j), x});
            try found.put(x, {});
        }
    }

    var iter = found.iterator();
    var sum: u64 = 0;
    while (iter.next()) |entry| {
        sum += entry.key_ptr.*;
    }
    print("{}\n", .{sum});
}

const ArbError = error {
    Overflow,
};

fn normalize(digits: []u8) ArbError!void {
    var i: usize = 0;
    while (i < digits.len-1) : (i += 1) {
        if (digits[i] >= 10) {
            digits[i+1] += digits[i] / 10;
            digits[i] = digits[i] % 10;
        } else {
            break;
        }
    }
    if (digits[digits.len-1] >= 10) {
        return ArbError.Overflow;
    }
}

fn good(digits: []u8) bool {
    var seen: [10]bool = .{false}**10;
    for (digits) |d| {
        if (seen[d]) {
            return false;
        } else {
            seen[d] = true;
        }
    }
    return !seen[0];
}

fn arbToInt(digits: []u8) u64 {
    var x: u64 = 0;
    var i: usize = digits.len;
    while (i > 0) {
        i -= 1;
        x *= 10;
        x += digits[i];
    }
    return x;
}

fn intToArb(n: u64, dest: []u8) usize {
    var i: usize = 0;
    var m = n;
    while (m > 0) : (i += 1) {
        dest[i] = @intCast(u8, (m % 10) & 0xFF);
        m /= 10;
    }
    while (i < dest.len) : (i += 1) {
        dest[i] = 0;
    }
    return i;
}
