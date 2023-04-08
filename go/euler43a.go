package main

import (
	"fmt"
	"strconv"
	"time"
)

const (
	max_product = 999
)

var (
	mod []int = []int{17, 13, 11, 7, 5, 3, 2}
	sum int
)

func main() {
	start := time.Now()
	in := make(chan string)
	go products(mod[0], in)
	var out chan string
	for i := 1; i < len(mod); i++ {
		out = make(chan string)
		go match(mod[i], in, out)
		in = out
	}

	for s := range out {
		t := string(digits(s).unseen()) + s
		x, _ := strconv.Atoi(t)
		sum += x
		fmt.Println(t)
	}
	fmt.Println("Result:", sum)
	fmt.Println(time.Now().Sub(start))
}

func products(n int, out chan string) {
	i := 1
	for {
		x := n * i
		if x > max_product {
			break
		}
		out <- fmt.Sprintf("%03d", x)
		i++
	}
	close(out)
}

func match(n int, in, out chan string) {
	for s := range in {
		for b := '0'; b <= '9'; b++ {
			t := string(b)
			x, _ := strconv.Atoi(t + s[:2])
			u := t + s
			if x % n == 0 && digits(u) != nil {
				out <- u
			}
		}
	}
	close(out)
}

type digitSet [10]bool

func digits(str string) *digitSet {
	var set digitSet
	for i := 0; i < len(str); i++ {
		b := str[i]
		if set[b - '0'] {
			return nil
		}
		set[b - '0'] = true
	}
	return &set
}

func (d *digitSet) unseen() byte {
	for i, bool := range d {
		if !bool {
			return byte(i) + '0'
		}
	}
	panic("no unseen digit")
}
