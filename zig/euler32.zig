const std = @import("std");
const fmt = std.fmt;
const math = std.math;
const log10 = std.math.log10;
const pow = std.math.pow;
const print = std.debug.print;

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    const allocator = arena.allocator();
    defer arena.deinit();

    var found = std.AutoHashMap(u64, void).init(allocator);
    defer found.deinit();

    var i: u64 = 2;

    while (i < 1e9) : (i += 1) {
        var seen: [10]bool = .{false}**10;
        if (!good(i, seen[0..])) continue;

        var j: u64 = 101;
        const p = -(2.0 * log10(@intToFloat(f32, i)) - 9.0) / 2.0;
        const max = @floatToInt(u64, pow(f32, 10, p));
        if (max <= 1) break;

        while (j <= max) : (j += 1) {
            var seen2 = seen;
            if (!good(j, seen2[0..])) continue;

            const x = i * j;
            if (!good(x, seen2[0..])) continue;

            var c: u8 = 0;
            for (seen2) |b| c += @boolToInt(b);
            if(c != 9) continue;

            print("{} x {} = {}\n", .{i, j, x});
            try found.put(x, {});
        }
    }

    var iter = found.iterator();
    var sum: u64 = 0;
    print("\n", .{});
    while (iter.next()) |entry| {
        print("{}\n", .{entry.key_ptr.*});
        sum += entry.key_ptr.*;
    }
    print("Sum {}\n", .{sum});
}

fn good(i: u64, seen: []bool) bool {
    var digbuf: [10]u8 = .{0}**10;
    const n = formatInt(digbuf[0..], i);
    for (digbuf[0..n]) |d| {
        const j = d-'0';
        if (seen[j]) {
            return false;
        } else {
            seen[j] = true;
        }
    }
    return !seen[0];
}

fn formatInt(buf: []u8, i: u64) usize {
    return fmt.formatIntBuf(buf, i, 10,
                            fmt.Case.lower,
                            fmt.FormatOptions {});
}
