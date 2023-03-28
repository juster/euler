package main

import (
	"strconv"
	"strings"
	"fmt"
)

const limit = int(999999999 / 2)

var max = 0

func main() {
	//buf := make([]byte, 0, 9)
	n := 0
	defer func() {
		fmt.Printf("%d pandigitals found\n", n)
	}()
	for x := int(1e9 - 1); x > int(9 * 1e8); x-- {
		s := strconv.Itoa(x)
		if strings.Contains(s, "0") {
			continue
		}
		if !isPandigital(s) {
			continue
		}
		n++
		if checkProducts([]byte(s)) {
			return
		}
	}
}

func isPandigital(s string) bool {
	if len(s) != 9 {
		return false
	}
	seen := make(map[rune]bool)
	for _, b := range s {
		if seen[b] {
			return false
		}
		seen[b] = true
	}
	return (len(seen) == 9)
}

func checkProducts(digits []byte) bool {
	InitLoop:
	for i := 1; i < len(digits); i++ {
		x, err := strconv.Atoi(string(digits[0:i]))
		if err != nil {
			panic(err)
		}
		rest := digits[i:]
		var j int
		for j = 2; len(rest) > 0; j++ {
			first := []byte(strconv.Itoa(x * j))
			if len(first) > len(rest) {
				continue InitLoop
			}
			for k, d := range first {
				if rest[k] != d {
					continue InitLoop
				}
			}
			rest = rest[len(first):]
		}
		fmt.Printf("%d x (1...%d) = %s\n", x, j-1, digits)
		return true
	}
	return false
}
