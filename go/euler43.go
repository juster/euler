package main

import (
	"fmt"
	"strconv"
)

func main() {
	sum := 0
	mod := []int{2, 3, 5, 7, 11, 13, 17}
	PermLoop:
	for s := range permute("0123456789") {
		for i, m := range mod {
			x, _ := strconv.Atoi(s[i+1:i+4])
			if x % m != 0 {
				continue PermLoop
			}
		}
		fmt.Println(s)
		x, _ := strconv.Atoi(s)
		sum += x
	}
	fmt.Println("Result", sum)
}

func permute(str string) chan string {
	ch := make(chan string)
	go permuteHeap([]byte(str), ch)
	return ch
} 

// https://en.wikipedia.org/wiki/Heap's_algorithm
func permuteHeap(s []byte, ch chan<- string) {
	n := len(s)
	c := make([]int, len(s))
	ch <- string(s)
	
	i := 1
	for i < n {
		if c[i] < i {
			j := c[i]
			if i % 2 == 0 {
				s[0], s[i] = s[i], s[0]
			} else {
				s[i], s[j] = s[j], s[i]
			}
			r := make([]byte, n)
			copy(r, s)
			ch <- string(r)
			c[i]++
			i = 1
		} else {
			c[i] = 0
			i++
		}
	}
	close(ch)
}
