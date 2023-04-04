package main

import (
	"strconv"
	"fmt"
)

const (
	limit = 1000000
)

func main() {
	ch := make(chan uint8)
	go generate(ch)
	x := 1
	for i, j := 1, 1; j <= limit; i++ {
		digit := <-ch
		if i == j {
			x *= int(digit)
			j *= 10
		}
	}
	fmt.Println("Result:", x)
}

func generate(out chan<- uint8) {
	i := 1
	for {
		for _, d := range strconv.Itoa(i) {
			out <-uint8(d - '0')
		}
		i++
	}	
}
