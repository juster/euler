package main
import "fmt"
const limit = 1000000
var primes = eratosthenes(limit).primes()
func main() {
	var y, n int
	for _, i := range primes {
		for j := 0; j + n - 1 < len(primes); j++ {
			if primes[j] > i {
				break
			}
			var x, m int
			for k := j; k < len(primes); k++ {
				p := primes[k]
				m++
				x += p
				if x == i && m > n {
					y = x
					n = m
					break
				}
				if x >= i {
					break
				}
			}
		}
	}
	x := 0
	for _, p := range primes {
		if x >= y { break }
		fmt.Println(p)
		x += p
	}
	fmt.Println(y, n)
}
