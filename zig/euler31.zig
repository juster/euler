const print = @import("std").debug.print;
const coins = [_]u64{1,2,5,10,20,50,100,200};
const n     = 200;

var count: [coins.len*(n+1)]u64 = .{0}**(coins.len*(n+1));

pub fn main() void {
    var mat = @ptrCast(*[coins.len][n+1]u64, &count);

    var i: usize = 0;
    while (i <= n) : (i += 1) {
        mat[0][i] = 1;
    }

    for (coins[1..coins.len]) |c,j| {
        // j starts at 0
        mat[j+1][0] = 1;
        i = 1;
        while (i <= n) : (i += 1) {
            mat[j+1][i] = mat[j][i];
            if (c <= i) {
                mat[j+1][i] += mat[j+1][i-c];
            }
        }
    }
    print("Problem 31 answer: {}\n", .{count[count.len-1]});
}
