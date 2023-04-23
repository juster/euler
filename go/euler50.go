package main

import "fmt"

const limit = 1_000_000

var sieve = eratosthenes(limit)
var sum = []int{0} // allows us a no-op for pivoting

func main() {
	x := sum[0]
	for i := range sieve.genPrimes(1) {
		x += i
		if x > limit {
			break
		}
		sum = append(sum, x)
	}

	// Loop through the sums, pivoting around j. We subtract i primes from
	// the beginning and add k primes to the end. Sum for the k succeeding
	// primes is sum[k] - sum[j].

	var n, a, b int
	for i := 0; i < len(sum); i++ {
		for j := i; j < len(sum); j++ {
		LoopK:
			for k := j; k < len(sum); k++ {
				x := sum[j] - sum[i] + (sum[k] - sum[j])
				switch {
				case x > limit:
					break LoopK
				case !sieve.isPrime(x):
					continue
				case k-i > b-a:
					n, a, b = x, i, k
				}
			}
		}
	}
	fmt.Println(n, a, b)
}
