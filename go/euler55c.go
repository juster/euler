package main

import (
	"fmt"
	"math/big"
	"time"
)

func main() {
	var count int
	start := time.Now()
Loop:
	for i := int64(1); i <= 10_000; i++ {
		x := big.NewInt(i)
		y := &big.Int{}
		reverse(x, y)
		for j := 1; j <= 50; j++ {
			x.Add(x, y)
			is_pal := reverse(x, y)
			if is_pal {
				continue Loop
			}
		}
		count++
	}
	fmt.Println("Answer:", count, time.Now().Sub(start))
}

func reverse(x, y *big.Int) bool {
	s := x.String()
	buf := make([]byte, len(s))
	pal := true

	i, j, m := 0, len(s)-1, len(s)/2
	for i = 0; i < m; i++ {
		if pal && s[i] != s[j] {
			pal = false
		}
		buf[j] = s[i]
		buf[i] = s[j]
		j--
	}
	if len(s)%2 == 1 {
		buf[m] = s[m]
	}

	_, ok := y.SetString(string(buf), 10)
	if !ok {
		panic("internal error: " + string(buf))
	}

	return pal
}
