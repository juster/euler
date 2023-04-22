package main

import (
	"fmt"
)

const limit = 10000

var sieve = eratosthenes(limit)
var found = make([]bool, limit+1)

func main() {
	var n, i, x, y int = 0, 1, 0, 0
	for {
		if x = 2 * i * i; x > limit { break }
		for p := 3; p < limit; p += 2 {
			if !sieve.isPrime(p) { continue }
			y = x + p
			switch{
			case y > limit || sieve.isPrime(y):
			case y % 2 == 0:
			default: found[y] = true; n++
			}
		}
		i++
	}
	fmt.Println("Composite numbers:", n)
	for i := 3; i < len(found); i += 2 {
		if sieve.isPrime(i) { continue }
		if found[i] { continue }
		fmt.Println("Result:", i)
		break
	}
}
