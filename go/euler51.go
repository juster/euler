package main

import (
	"fmt"
	"math"
	"github.com/juster/euler/go/euler"
	"strconv"
	"strings"
)

const digits_len = 6
const group_size = 8
const blank_count = 3

var min = int(math.Pow10(digits_len - 1))
var max = int(math.Pow10(digits_len))
var sieve = euler.Eratosthenes(max)
var digits [digits_len]int

func init() {
	for i := range digits {
		digits[i] = i
	}
}

func main() {
	for repl := range perms(blank_count, digits[:]) {
		seen := make(map[string]int)
		group := make(map[string]int)

	PrimeLoop:
		for p := range sieve.GenPrimesFrom(min) {
			a := strconv.Itoa(p)
			b := strings.Builder{}
			var k byte
			var j int
			for i := 0; i < blank_count && j < len(a); j++ {
				switch {
				case repl[i] != j:
					b.WriteByte(a[j])
					continue
				case k == 0:
					k = a[j]
				case k != a[j]:
					continue PrimeLoop
				}
				i++
				b.WriteByte('*')
				continue
			}
			if j < len(a) {
				b.WriteString(a[j:])
			}
			s := b.String()
			seen[s] += 1
			if _, ok := group[s]; !ok {
				group[s] = p
			}
		}

		for m, n := range seen {
			if n == group_size {
				fmt.Printf("%s: %d\n", m, group[m])
				return
			}
		}
	}
}

// like Knuth's TAOCP with length limit added
func perms(n int, a []int) chan []int {
	out := make(chan []int)
	go func(){
		if n == 0 {
			out <-nil
			close(out)
			return
		}
		// only creates permutations with increasing elements
		for i := 0; i + n - 1 < len(a); i++ {
			j := a[i]
			b := make([]int, len(a) - (i+1))
			copy(b, a[i+1:])
			for c := range perms(n-1, b) {
				d := make([]int, n)
				d[0] = j
				copy(d[1:], c)
				out <-d
			}
		}
		close(out)
	}()
	return out
}
