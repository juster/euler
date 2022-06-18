const std = @import("std");
const fmt = std.fmt;
const math = std.math;
const log10 = std.math.log10;
const pow = std.math.pow;
const floor = std.math.floor;
const print = std.debug.print;

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    const allocator = arena.allocator();
    defer arena.deinit();

    var found = std.AutoHashMap(u64, void).init(allocator);
    defer found.deinit();

    // alpha(&found);
    try beta(&found);

    var iter = found.iterator();
    var sum: u64 = 0;
    print("\n", .{});
    while (iter.next()) |entry| {
        print("{}\n", .{entry.key_ptr.*});
        sum += entry.key_ptr.*;
    }
    print("Sum {}\n", .{sum});
}

fn alpha(found: *std.AutoHashMap) !void {
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
            try found.*.put(x, {});
        }
    }
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

fn beta(found: *std.AutoHashMap(u64, void)) !void {
    var i: u64 = 2;
    while(i < 1e9) : (i += 1) {
        var r: [2]u64 = .{0,0};
        range(i, comptime 9, &r);
        if(r[0] < i) break;
        var j = r[0]+1;

        print("{} {} {}\n", .{i, r[0], r[1]});
        while(j <= r[1]) : (j += 1) {
            // print("{}\n", .{floor(2*flog10(i) + 2*flog10(j))});
            if(floor(2*flog10(i) + 2*flog10(j)) != 8.0)
                continue;
            var x = i*j;
            // print("DBG {}\n", .{x});
            if(digsum(i) + digsum(j) + digsum(x) != 45)
                continue;
            print("{} x {} = {}\n", .{i, j, x});
            try found.*.put(x, {});
        }
    }
}

fn range(i: u64, comptime digits: u8, dest: *[2]u64) void {
    const x = @intToFloat(f32, i);
    const n = @intToFloat(f32, digits);
    const p1 = -(2.0 * log10(x) - (n-1.0)) / 2.0;
    const p2 = -(2.0 * log10(x) - n) / 2.0;
    dest[0] = @floatToInt(u64, pow(f32, 10, p1));
    dest[1] = @floatToInt(u64, pow(f32, 10, p2));
}

fn flog10(i: u64) f32 {
    return log10(@intToFloat(f32, i));
}

fn digsum(i: u64) u64 {
    var sum: u64 = 0;
    var x = i;
    while (x > 0) {
        sum += x % 10;
        x /= 10;
    }
    return sum;
}
