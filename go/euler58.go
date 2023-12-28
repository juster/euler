package main

import (
	"fmt"
	"time"
)

func main() {
	start := time.Now()
	var i, n, primes, total int
	i, total = 1, 1
	for {
		n += 2
		total += 4
		for j := 0; j < 4; j++ {
			i += n
			if isPrime(i) {
				primes++
			}
		}
		if 100*primes/total < 10 {
			break
		}
	}
	fmt.Println("Answer:", n+1, "in", time.Now().Sub(start))
}

func isPrime(x int) bool {
	if x%2 == 0 || x%3 == 0 {
		return false
	}
	for i := 5; i*i <= x; i += 6 {
		if x%i == 0 || x%(i+2) == 0 {
			return false
		}
	}
	return true
}
