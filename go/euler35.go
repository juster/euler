package main

import "fmt"

const limit = 1000000

func main() {
	c := 0
	sieve := eratosthenes(limit)
	Outer: for i := 1; i < limit; i++ {
		s := fmt.Sprintf("%d", i)
		var x int
		for i := 0; i < len(s); i++ {
			fmt.Sscanf(s, "%d", &x)
			if(!sieve.isPrime(x)){
				continue Outer
			}
			rotateLeft(&s);
		}
		c++
	}
	fmt.Printf("Result: %d\n", c)
}

func rotateLeft(ptr *string) {
	s := *ptr
	slice := []byte(s)
	b := slice[0]
	for i := 1; i < len(slice); i++ {
		slice[i-1] = slice[i]
	}
	slice[len(slice)-1] = b
	*ptr = string(slice)
}
