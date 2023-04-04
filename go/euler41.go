package main

import (
	"fmt"
	"sort"
	"strconv"
)

const (
	limit = 999999999
)

func main() {
	if !isPandigital(1234) {
		panic("bug")
	}
	if isPandigital(1111) {
		panic("bug")
	}
	if !isPandigital(928753461) {
		panic("bug")
	}
	s := eratosthenes(limit)
	for i := limit; i >= 0; i-- {
		if s.isPrime(i) && isPandigital(i) {
			fmt.Println("Result:", i)
			return
		}
	}
}

func isPandigital(n int) bool {
	a := []byte(strconv.Itoa(n))
	sort.Slice(a, func(i, j int) bool {
		return a[i] < a[j]
	})
	if a[0] == '0' {
		return false
	}
	x := byte('1')
	for i := 0; i < len(a); i++ {
		if x != a[i] {
			return false
		}
		x += 1
	}
	return true
}
