package main
import (
	"fmt"
	"sort"
	"strconv"
	"strings"
)
const limit = 10000
const seq_count = 3
var sieve = eratosthenes(limit)

func main() {
	for i := range sieve.genPrimes(2) {
		//fmt.Println(i)
		DeltaLoop:
		for j := 1; i + 2*j < limit; j++ {
			// find the delta
			for x, k := i, 1; k < seq_count; k++ {
				x += j
				if x > limit || !sieve.isPrime(x) || !isPalindrome(i, x) {
					continue DeltaLoop
				}
			}
			for k := 0; k < seq_count; k++ {
				fmt.Printf("%d", i + j*k)
			}
			fmt.Print("\n")
		}
	}
}

func isPalindrome(x, y int) bool {
	a, b := strconv.Itoa(x), strconv.Itoa(y)
	if len(a) != len(b) {
		return false
	}
	as, bs := strings.Split(a, ""), strings.Split(b, "")
	sort.Strings(as)
	sort.Strings(bs)
	for i, s := range as {
		if bs[i] != s {
			return false
		}
	}
	return true
}

