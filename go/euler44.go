package main

import (
	"fmt"
	"math"
	"time"
)

const (
	limit = 5000
)

var (
	penta [limit]int
	min = math.MaxInt
)

func main() {
	start := time.Now()
	ch := make(chan int)
	go generate(ch)
	for i := 0; i < limit; i++ {
		penta[i] = <-ch
	}
	for i := 0; i < limit; i++ {
		for j := i+1; j < limit; j++ {
			x := penta[i] + penta[j]
			if !pentagonal(x) {
				continue
			}
			x = penta[j] - penta[i]
			if !pentagonal(x) {
				continue
			}
			if x < min {
				min = x
			}
			fmt.Println(penta[i], penta[j])		
		}
	}
	
	fmt.Println("Result:", min, time.Now().Sub(start))
}

func generate(out chan int) {
	x := 1
	y := 3
	for {
		out <-x
		y += 3
		x += y - 2
	}
}

// The inverse of ...
//
//     3n^2 - n         1 + sqrt(1 + 24x)
// x = --------  is n = -----------------
//        2                     6
// 
func pentagonal(n int) bool {
	x, f1 := math.Modf(math.Sqrt(float64(n) * 24.0 + 1.0))
	if f1 != 0.0 {
		return false
	}
	_, f2 := math.Modf((x + 1.0) / 6.0)
	if f2 != 0.0 {
		return false
	}
	return true
}

