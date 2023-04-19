package main

import (
	"fmt"
)

func main() {
	triCh, pentaCh, hexCh := make(chan int), make(chan int), make(chan int)
	go genTri(triCh)
	go genPenta(pentaCh)
	go genHexa(hexCh)
	ff(285, triCh)
	ff(165, pentaCh)
	ff(143, hexCh)
	x, y, z := <-triCh, <-pentaCh, <-hexCh

	for {
		if x < y {
			x = <-triCh
			continue
		}
		if y < z {
			y = <-pentaCh
			continue
		}
		if z < y {
			z = <-hexCh
			continue
		}
		fmt.Println("Results:", x, y, z)
		break
	}
}

func ff(n int, ch chan int) {
	for i := 0; i < n; i++ {
		<-ch
	}
}

func genTri(out chan int) {
	x := 1
	y := 0
	for {
		out <-x
		y += 1
		x += y + 1
	}
}

func genPenta(out chan int) {
	x := 1
	y := 0
	for {
		out <-x
		y += 3
		x += y + 1
	}
}

func genHexa(out chan int) {
	x := 1
	y := 0
	for {
		out <-x
		y += 4
		x += y + 1
	}
}
