package main

import (
	"fmt"
)

func main() {
	ch5, ch6 := gen(5, 165), gen(6, 143)
	y, z := <-ch5, <-ch6

	for {
		switch {
		case y < z: y = <-ch5; continue
		case z < y: z = <-ch6; continue
		}
		fmt.Println("Results:", y, z)
		break
	}
}

func gen(shape, ff int) chan int {
	out := make(chan int)
	shape -= 2
	go func(x, y int){
		for i := 1; ; i++ {
			if i > ff { out <-x }
			y += shape
			x += y + 1
		}
	}(1, 0)
	return out
}
