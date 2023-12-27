package euler57

// cmdline: go test -bench=. -benchtime=1000x euler57_test.go

import (
	"fmt"
	"math/big"
	"testing"
)

func BenchmarkEuler(b *testing.B) {
	var count int
	var num, denom, tmp, big2 *big.Int
	num, big2 = big.NewInt(1), big.NewInt(2)
	denom, tmp = &big.Int{}, &big.Int{}
	denom.Set(big2)
	for i := 0; i < b.N; i++ {
		// tmp is 1 + num/denom
		tmp.Add(tmp.Set(num), denom)
		//fmt.Println("*DBG*", i, tmp, denom)
		if len(tmp.String()) > len(denom.String()) {
			count++
		}

		tmp.Mul(big2, tmp.Set(denom))
		num.Add(num, tmp)
		num, denom = denom, num
	}
	fmt.Println("Answer:", count)
}
