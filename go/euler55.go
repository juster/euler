package main

import (
	"fmt"
	"math/big"
	"time"
)

const (
	recurse_max = 50
	loop_max    = 10000
)

var (
	count, top int
	stack      [2 * recurse_max]big.Int
	cache      map[string]bool
)

func init() {
	cache = make(map[string]bool)
}

func push(x, y *big.Int) {
	stack[top+0] = *x
	stack[top+1] = *y
	top += 2
}

// Cache whether a palindrome was found.
func store(found bool) {
	if found {
		for _, x := range stack[:top] {
			cache[x.String()] = true
		}
	} else {
		count++
	}
	top = 0
}

func main() {
	start := time.Now()
	for i := int64(1); i < loop_max; i++ {
		var pal bool
		x := big.NewInt(i)
	Loop:
		for j := 0; j < recurse_max; j++ {
			s := x.String()
			if pal = cache[s]; pal && top > 0 {
				// Don't stop if the operands are palindromes. The sum must be a palindrome
				// to reject it as a Lychrael number.
				break Loop
			}
			var y *big.Int
			y, pal = reverse(x)
			push(x, y)
			if pal {
				if top > 2 {
					//fmt.Println("*DBG* palindrome:", i, j, y)
					break Loop
				}
			}
			x = x.Add(x, y)
		}
		if !pal {
			fmt.Println("Found", i)
		}
		store(pal)
	}
	fmt.Println("Answer", count, len(cache), time.Now().Sub(start))
}

func reverse(x *big.Int) (*big.Int, bool) {
	s := x.String()
	buf := make([]byte, len(s))
	pal := true

	for i := 0; i < len(s)/2; i++ {
		j := len(s) - i - 1
		if s[i] != s[j] {
			pal = false
		}
		buf[j] = s[i]
		buf[i] = s[j]
	}
	if len(s)%2 == 1 {
		j := len(s) / 2
		buf[j] = s[j]
	}

	y := &big.Int{}
	_, ok := y.SetString(string(buf), 10)
	if !ok {
		panic("internal error: " + string(buf))
	}

	return y, pal
}
