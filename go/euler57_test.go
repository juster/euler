package euler57

// cmdline: go test -bench=. -benchtime=1000x euler57_test.go

import (
	"fmt"
	"math/big"
	"testing"
)

func BenchmarkEuler(b *testing.B) {
	var count int
	var rat, big1, big2 big.Rat
	var tmp big.Int

	rat.Set(big.NewRat(2, 1))
	big2.Set(&rat)
	big1.Set(big.NewRat(1, 1))

	for i := 0; i < b.N; i++ {
		rat.Inv(&rat)
		tmp.Add(tmp.Set(rat.Num()), rat.Denom())
		//fmt.Println("*DBG*", i, tmp, denom)
		if len(tmp.String()) > len(rat.Denom().String()) {
			count++
		}
		rat.Add(&rat, &big2)
	}
	fmt.Println("Answer:", count)
}
