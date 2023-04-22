package main

import (
	"fmt"
	"math"
)

const count = 4

func main() {
	var n, m int
	for i := 4; ; i++ {
		m = 0
		x, max := i, int(math.Sqrt(float64(i)))
		// No need for primality checks or sieves.
		// -Barker on the problem forum
		for j := 2; j <= x && j <= max; j++ {
			if x%j == 0 {
				m++
				x /= j
				for x%j == 0 {
					x /= j
				}
			}
		}
		if x > 1 {
			// what remains is a prime factor > sqrt(x)
			m++
		}
		if m != count {
			n = 0
			continue
		}
		if n++; n == count {
			fmt.Println("Result:", i-count+1)
			return
		}
	}
}
