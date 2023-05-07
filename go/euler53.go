package main
import (
	"math/big"
	"fmt"
)
const limit = 100
var ratLimit = big.NewRat(1_000_000, 1)

func main() {
	var c int
	for r := int64(1); r < limit; r++ {
		f := big.NewRat(1, 1)
		var x int64
		for n := r+1; n <= limit; n++ {
			x++
			f.Mul(f, big.NewRat(n, x))
			if f.Cmp(ratLimit) > 0 {
				c++
			}
		}
	}
	fmt.Println("Results:", c)
}
