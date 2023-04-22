package main

import (
	"fmt"
	"math/big"
)

const limit = 1000

func main() {
	var sum big.Int
	var i int64
	for i = 1; i <= limit; i++ {
		x := big.NewInt(i)
		x.Exp(x, x, nil)
		sum.Add(&sum, x)
	}
	digits := sum.String()
	fmt.Println(digits[len(digits)-10:])
}
