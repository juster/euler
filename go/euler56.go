package main

import (
	"fmt"
	"math/big"
	"time"
)

const limit = 100

func main() {
	start := time.Now()
	var max int
	var x, y big.Int
	for i := int64(2); i < limit; i++ {
		x.SetInt64(i)
		y.Set(&x)
		for j := 2; j < limit; j++ {
			y.Mul(&x, &y)
			if sum := digitalSum(&y); sum > max {
				max = sum
			}
		}
	}
	fmt.Printf("Answer: %d in %s\n", max, time.Now().Sub(start))
}

func digitalSum(x *big.Int) (sum int) {
	s := x.String()
	for i := 0; i < len(s); i++ {
		sum += int(s[i]) - '0'
	}
	return
}
