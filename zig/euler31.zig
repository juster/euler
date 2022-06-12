const print = @import("std").debug.print;
const coins = [_]u64{1,2,5,10,20,50,100,200};
const n     = 200;

var count: [coins.len*n]u64 = .{0}**(coins.len*n);

pub fn main() void {
    var mat = @ptrCast(*[coins.len][n]u64, &count);

    var i: usize = 0;
    while (i < n) : (i += 1) {
        mat[0][i] = 1;
    }

    i = 1;
    for (coins[1..coins.len]) |c| {
        var j: usize = 1;
        while (j < n) : (j += 1) {
            mat[i][j] = mat[i-1][j];
            if (c == j) {
                mat[i][j] += 1;
            } else if (c < j) {
                mat[i][j] += mat[i][j-c];
            }
        }

        i += 1;
    }
    print("Problem 31 answer: {}\n", .{count[count.len-1]});
}
