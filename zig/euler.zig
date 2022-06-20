pub fn euclid(comptime T:anytype, x: T, y: T) T {
    var a = x;
    var b = y;
    while (b != 0) {
        const t = b;
        b = a % b;
        a = t;
    }
    return a;
}

pub fn primesieve(dest: []bool) void {
    dest[0] = false;
    dest[1] = false;
    var i: usize = 2;
    while (i < dest.len) : (i += 1) {
        dest[i] = true;
    }
    i = 2;
    while (i < dest.len) : (i += 1) {
        var j = i + i;
        while (j < dest.len) : (j += i) {
            dest[j] = false;
        }
    }
}
