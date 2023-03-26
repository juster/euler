package main

import "fmt"

const limit = 1000000

func main() {
	primeSieve := eratosthenes(limit)
	rotated := make([]int, limit+1)
	for i := 1; i <= limit; i++ {
		if primeSieve.isPrime(i) {
			j := rotateLeft(i)
			rotated[i] = j
		} else {
			rotated[i] = 0
		}
	}
	n := 0
	for i := 1; i <= limit; i++ {
		for j := rotated[i]; j > 0; j = rotated[j] {
			if j == i {
				n++
				break
			}
		}
	}
	fmt.Printf("Result: %d\n", n)
}

func rotateLeft(i int) int {
	var x int
	s := fmt.Sprintf("%d", i)
	slice := []byte(s)
	if len(slice) > 1 && slice[1] == '0' {
		// Special case: rotating this number changes the number of digits
		// in the result and is invalid.
		return 0
	}
	fmt.Sscanf(string(append(slice[1:len(slice)], slice[0])), "%d", &x)
	return x
}
