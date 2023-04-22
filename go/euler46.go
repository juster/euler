package main

import (
	"fmt"
	"math"
)

const limit = 10000

var sieve = eratosthenes(limit)

func main() {
	var i, j, k int
	// For every odd composite number, i.
	CompositeLoop:
	for i = 9; i < limit; i += 2 {
		if sieve.isPrime(i) { continue }
		// ... and every prime number j smaller than i
		for j = 1; j < i; j += 2 {
			if !sieve.isPrime(j) { continue }
			if k = i - j; k % 2 == 1 { continue }
			if _, f := math.Modf(math.Sqrt(float64(k / 2))); f != 0.0 { continue }
			// ... find first i where i != j + 2k^2
			continue CompositeLoop
		}
		fmt.Println("Result:", i)
		return
	}
}
