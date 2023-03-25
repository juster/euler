package main

import (
	"fmt"
)

var x = 1
var y = 1

func main() {
	for i := 1; i <= 9; i++ {
		for j := 1; j <= 9; j++ {
			for k := 1; k <= 9; k++ {
				// j/k is the fraction on the rhs
				// a/b is the fraction on the lhs
				if j == i || i == k {
					continue
				}
				a := 10 * j + i
				b := 10 * i + k
				if a * k == b * j {
					fmt.Printf("%d/%d = %d/%d\n", a, b, j, k)
					x *= a
					y *= b
				}
			}
		}
	}
	z := euclid(x, y)
	x /= z
	y /= z
	fmt.Printf("%d/%d\n", x, y)
}
