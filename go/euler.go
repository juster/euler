package main

func euclid(x int, y int) int {
	a := x
	b := y
	for b != 0 {
		var c = b
		b = a % b
		a = c
	}
	return a
}
