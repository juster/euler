package main

import (
	"fmt"
	"strconv"
)

func main() {
	sum := 0
	mod := []int{2, 3, 5, 7, 11, 13, 17}
	s := []byte("0123456789")
	in := make(chan []byte)
	out := make(chan []byte)
	go permute(out, in)
	PermLoop:
	for {
    	out <- s
		s, ok := <-in
		if !ok {
			break
		}
		for i, m := range mod {
			x, _ := strconv.Atoi(string(s[i+1:i+4]))
			if x % m != 0 {
				continue PermLoop
			}
		}
		fmt.Println(s)
		x, _ := strconv.Atoi(string(s))
		sum += x
	}
	fmt.Println("Result", sum)
}

// https://en.wikipedia.org/wiki/Heap's_algorithm
func permute(in, out chan []byte) {
	s := <-in
	n := len(s)
	c := make([]int, len(s))
	out <- s

	s = <-in
	i := 1
	for i < n {
		if c[i] < i {
			j := c[i]
			if i % 2 == 0 {
				s[0], s[i] = s[i], s[0]
			} else {
				s[i], s[j] = s[j], s[i]
			}
			out <- s
			s = <-in
			c[i]++
			i = 1
		} else {
			c[i] = 0
			i++
		}
	}
	close(out)
}
