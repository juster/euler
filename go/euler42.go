package main

import (
	"bytes"
	"fmt"
	"math"
	"os"
)

func main() {
	wchan := make(chan []byte)
	schan := make(chan int)
	go words(wchan)
	go wordsums(schan, wchan)

	c := 0
	for s := range schan {
		// x = (n*(n+1))/2 = (n^2 + n)/2
		// => n^2 + n - 2x = 0
		x := (-1.0 - math.Sqrt(1.0+8.0*float64(s))) / 2.0
		if _, f := math.Modf(x); f == 0.0 {
			c++
		}
	}

	fmt.Println("Results:", c)
}

func words(out chan<- []byte) {
	buf, err := os.ReadFile("p042_words.txt")
	if err != nil {
		panic(err)
	}
	for _, w := range bytes.Split(buf, []byte(",")) {
		out <- w
	}
	close(out)
}

func wordsums(out chan<- int, in <-chan []byte) {
	for w := range in {
		n := 0
		for i := 1; i < len(w)-1; i++ {
			n += int(w[i] - byte('A') + 1)
		}
		out <- n
	}
	close(out)
}
