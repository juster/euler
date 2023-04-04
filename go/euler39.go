package main

import (
	"fmt"
)

const limit = 1000

/*
My first attempt at this failed but with help from rayfil's post I
reduced this properly.

a^2 + b^2 = c^2
a + b + c = p => c = p - a - b
=> a^2 + b^2 = (p - a - b)^2
=> a^2 + b^2 = p^2 - 2pa - 2pb + a^2 + 2ab + b^2
=> (p^2)/2 = -ab + pa + pb
=> p/2 - a - b = -ab/p
=> p/2 + ab/p = a + b
=> p^2/2p + 2ab/2p = a + b
=> p^2/2p + 2ab/2p - 2ap/2p = b
=> p^2/2p - 2ap/2p = b - 2ab/2p
=> p^2/2p - 2ap/2p = 2bp/2p - 2ab/2p
=> p^2 - 2ap = 2bp - 2ab
=> p^2 - 2ap = b(2p - 2a)
=> b = (p^2 - 2ap)/(2p - 2a)

*/

func main() {
	n := make([]int, 1+limit)
	// very interesting point from rayfil: the perimeter can only be even
	for p := 2; p <= limit; p += 2 {
		for a := 2; a < p; a += 1 {
			x := (p*p - 2*a*p)
			y := (2*p - 2*a)
			if x % y != 0 {
				continue
			}
			if x / y < a {
				break
			}
			n[p]++
		}
	}
	p, m := 0, 0
	for i, x := range n {
		if x > m {
			p, m = i, x
		}
	}
	fmt.Println("Result:", p, m)
}
