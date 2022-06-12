const std = @import("std");
const print = std.debug.print;
const Allocator = std.mem.Allocator;

const coins = [_]u64{1,2,5,10,20,50,100,200};

fn dp31(n: u64) !u64 {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    var alloc = arena.allocator();

    var count = try alloc.alloc(u64, n+1);
    var i: u64 = 1;
    while (i <= n) : (i += 1) {
        count[i] = 0;
    }
    count[0] = 1;

    for (coins) |c| {
        i = 1;
        while (i <= n) : (i += 1) {
            if (c <= i) {
                count[i] += count[i-c];
            }
        }
    }

    return count[n];
}

pub fn main() void {
    print("Problem 31 answer: {}\n", .{dp31(1000)});
}
