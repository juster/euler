package main

import (
	"fmt"
	"math/big"
	"time"
)

const (
	search_limit = 10_000
	recurse_max  = 50
)

var (
	skip [search_limit + 1]bool
)

func main() {
	var count int
	var x, y *big.Int
	y = &big.Int{}
	start := time.Now()
Loop:
	for i := int64(1); i <= search_limit; i++ {
		x = big.NewInt(i)
		if skip[i] {
			continue Loop
		}
		reverseIsPal(x, y)
		rev := y.Int64()
		for j := 1; j <= recurse_max; j++ {
			x.Add(x, y)
			if reverseIsPal(x, y) {
				skip[rev] = true
				continue Loop
			}
		}
		count++
	}
	fmt.Println("Answer:", count, "in", time.Now().Sub(start))
}

func reverseIsPal(src, dst *big.Int) bool {
	s := src.String()
	n := len(s)
	buf := make([]byte, n)
	for i := 0; i < n; i++ {
		buf[n-i-1] = s[i]
	}
	t := string(buf)
	dst.SetString(t, 10)
	return s == t
}
