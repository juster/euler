package main

import (
	"strconv"
	"strings"
	"math"
	"fmt"
)

var max = 0

const digitCount = 9

func main() {
	candidates := make(chan string)
	pans := make(chan string)
	go generate(candidates)
	go filter(candidates, pans)
	fmt.Println(<-pans)
}

func generate(ch chan<- string) {
	for i := float64(digitCount); i >= 0; i-- {
		min := 9 * int(math.Pow(10, i))
		max := 10 * int(math.Pow(10, i))
		var buf string
		for j := max - 1; j >= min; j-- {
			buf = strconv.Itoa(j)
			if len(buf) >= 9 {
				break
			}
			for k := 2; k <= 9 && len(buf) < 9; k++ {
				buf += strconv.Itoa(j * k)
			}
			if len(buf) == 9 {
				ch <-buf
			}
		}
	}
	close(ch)
}

func filter(src <-chan string, dst chan<- string) {
	FilterLoop:
	for s := range src {
		if strings.Contains(s, "0") {
			continue FilterLoop
		}
		seen := make(map[rune]bool)
		for _, b := range s {
			if seen[b] {
				continue FilterLoop
			}
			seen[b] = true
		}
		if len(seen) == 9 {
			dst <-s
		}
	}
	close(dst)
}
