package euler

func Euclid(x int, y int) int {
	a := x
	b := y
	for b != 0 {
		var c = b
		b = a % b
		a = c
	}
	return a
}

func IsPrime(x int) bool {
	if x % 2 == 0 {
		return false
	}
	for i := 3; i * i <= x; i += 2 {
		if x % i == 0 {
			return false
		}
	}
	return true
}
