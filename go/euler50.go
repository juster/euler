package main

import "fmt"
import "github.com/juster/euler/go/euler"

const limit = 1_000_000

var sieve = euler.Eratosthenes(limit)
var sum = []int{0} // allows us a no-op for skipping

func main() {
	x := sum[0]
	for i := range sieve.GenPrimes() {
		x += i
		if x > limit {
			break
		}
		sum = append(sum, x)
	}

	// Subtract i primes from the beginning of sum[j] to see if that makes
	// the sum prime. Keep the longest sequence.

	n, a, b := 1, 0, 0
	for i := 0; i < len(sum); i++ {
		for j := i + n; j < len(sum); j++ {
			x := sum[j] - sum[i]
			switch {
			case !sieve.IsPrime(x):
				continue
			case j-i > b-a:
				n, a, b = x, i, j
			}
		}
	}
	fmt.Println(n, a, b)
}
