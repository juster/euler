package main

import (
	"fmt"
)

func main() {
	ch3, ch5, ch6 := gen(3, 285), gen(5, 165), gen(6, 143)
	x, y, z := <-ch3, <-ch5, <-ch6

	for {
		switch {
		case x < y: x = <-ch3; continue
		case y < z: y = <-ch5; continue
		case z < y: z = <-ch6; continue
		}
		fmt.Println("Results:", x, y, z)
		break
	}
}

func gen(shape, ff int) chan int {
	out := make(chan int)
	shape -= 2
	go func(x, y int){
		for {
			out <-x
			y += shape
			x += y + 1
		}
	}(1, 0)

	// fast-forward a certain amount
	for i := 0; i < ff; i++ {
		_ = <-out
	}
	return out
}
