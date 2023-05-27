package main

import (
	"fmt"
	"math"
	"math/big"
	"strconv"
	"strings"
)

const (
	input_digits = 4
	recurse_max = 50
)

type state struct {
	stack []*big.Int
	cache map[string]bool
}

func NewState() *state {
	return &state{
		make([]*big.Int, 2 * recurse_max),
		make(map[string]bool),
	}
}

func (s *state) Push(x *big.Int) {
	n := len(s.stack)
	s.stack = s.stack[:n+1]
	s.stack[n] = x
}

func (s *state) Finish(lychrel bool) {
	for _, y := range s.stack {
		s.cache[y.String()] = lychrel
	}
	s.stack = s.stack[:0]
}

func main() {
	state := NewState()
	in := pairs(input_digits)
	n := 0
OuterLoop:
	for p := range in {
		a := p.a
		b := p.b
	InnerLoop:
		for i := 0; i < recurse_max; i++ {
			c := &big.Int{}
			c.Add(a, b)

			s := c.String()
			if lychrel, seen := state.cache[s]; seen {
				if lychrel {
					n++
				}
				state.Finish(lychrel)
				continue OuterLoop
			}
			if s[len(s)-1] == '0' {
				state.cache[s] = true
				break InnerLoop
			}
			if isPalindrome(s) {
				fmt.Println(p.a, p.b, c)
				state.cache[s] = false
				state.Finish(false)
				continue OuterLoop
			}

			state.Push(a)
			state.Push(b)
			a = c
			b = reverse(a)
		}
		state.Finish(true)
		fmt.Println(p.a, p.b, "(found)")
		n++
		if a.Cmp(b) != 0 {
			n++
		}
	}
	fmt.Println("Result", n)
}

type pair struct {
	a, b *big.Int
}

func pairs(digits int) <-chan *pair  {
	out := make(chan *pair)
	go func() {
		for n := 1; n <= digits; n++ {
			for i := 1; i <= 9; i++ {
				x, _ := strconv.Atoi(strings.Repeat("1", n))
				beg := i * x
				top := (i + 1) * int(math.Pow(10.0, float64(n-1)))
				//fmt.Println(beg, top, top-beg)

				for j := beg; j < top; j++ {
					if j % 10 == 0 {
						continue
					}
					a := big.NewInt(int64(j))
					b := reverse(a)
					out <- &pair{a, b}
				}
			}
		}
		close(out)
	}()
	return out
}

func reverse(x *big.Int) *big.Int {
	s := x.String()
	buf := make([]byte, len(s))
	for i := 0; i < len(s); i++ {
		buf[len(s) - i - 1] = s[i]
	}
	y, _ := strconv.Atoi(string(buf))
	return big.NewInt(int64(y))
}

func isPalindrome(s string) bool {
	for i := 0; i < len(s)/2; i++ {
		if s[i] != s[len(s)-i-1] {
			return false
		}
	}
	return true
}
