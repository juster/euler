const print = @import("std").debug.print;
const coins = [_]u64{1,2,5,10,20,50,100,200};
const n     = 200;

var count: [n+1]u64 = .{1} ++ .{0}**n;

pub fn main() void {
    var i: u64 = 1;

    for (coins) |c| {
        i = 1;
        while (i <= n) : (i += 1) {
            if (c <= i) {
                count[i] += count[i-c];
            }
        }
    }
    print("Problem 31 answer: {}\n", .{count[n]});
}
