package main

import (
	"fmt"
	"math/big"
	"time"
)

const (
	recurse_max = 50
	loop_max    = 9999
)

// The lychrael check starting at x, y results in z after n iterations.

type step struct {
	x, y big.Int
	n int
}

type result struct {
	z big.Int
	n int
}

var (
	count, top int
	stack      [recurse_max]step
	// *result is nil if the lychrael check results in a palindrome at some point
	cache      map[string]*result
)

func init() {
	cache = make(map[string]*result)
}

func push(n int, x, y *big.Int) {
	dest := &stack[top]
	dest.x.Set(x)
	dest.y.Set(y)
	dest.n = n
	top++
}

// Cache the last result of the Lychrael check operation. If end is nil then a palindrome was found.

func reset(end *big.Int) {
	// top is the number of operations.
	for i := 0; i < top; i++ {
		step := &stack[i]
		var r *result
		if end != nil {
			r = &result{n: step.n - i + 1}
			r.z.Set(end)
			//fmt.Printf("*DBG* store: %s + %s == %s, %d\n", &step.x, &step.y, end, r.n)
		}
		cache[step.x.String()] = r
		cache[step.y.String()] = r
	}
	top = 0
}

func main() {
	n := 0
	start := time.Now()
	for i := int64(1); i <= loop_max; i++ {
		x := big.NewInt(i)
	Loop:
		for j := 1; j <= recurse_max; j++ {
			s := x.String()
			if ff, ok := cache[s]; ok {
				n++
				switch {
				case ff == nil && j > 1:
					// Previously, a palindrome was found eventually.
					x = nil
					break Loop
				case ff != nil:
					// Fast-forward to the last result that was not a palindrome.
					//fmt.Printf("*DBG* j=%d x=%s\n*DBG* n=%d z=%s\n", j, x, ff.n, &ff.z)
					x.Set(&ff.z)
					j += ff.n - 1 // j gets incremented *and* don't count this iteration
					continue Loop
				}
			}
			y, pal := reverse(x)
			if pal && j > 1 {
				//fmt.Println("*DBG* palindrome:", i, j, y)
				x = nil
				break Loop
			}
			push(j, x, y)
			x = x.Add(x, y)
		}
		reset(x)
		if x != nil {
			fmt.Println("Found", i)
			count++
		}
	}
	fmt.Println("Answer", count, n, len(cache), time.Now().Sub(start))
}

func reverse(x *big.Int) (*big.Int, bool) {
	s := x.String()
	buf := make([]byte, len(s))
	pal := true

	i, j, m := 0, len(s) - 1, len(s)/2
	for i < m {
		if s[i] != s[j] {
			pal = false
		}
		buf[j] = s[i]
		buf[i] = s[j]
		i++
		j--
	}
	if len(s)%2 == 1 {
		buf[m] = s[m]
	}

	y := &big.Int{}
	_, ok := y.SetString(string(buf), 10)
	if !ok {
		panic("internal error: " + string(buf))
	}

	return y, pal
}
