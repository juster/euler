package main
import ("github.com/juster/euler/go/euler"; "fmt")
const limit = 6

func main() {
Loop:
	for a := 1; ; a++ {
		n := euler.DigitCount(a)
		var b int
		for c := 1; c <= limit; c++ {
			b += a
			m := euler.DigitCount(b)
			for i, d := range m {
				if n[i] != d {
					continue Loop
				}
			}
		}
		var x int
		for i := 1; i <= limit; i++ {
			x += a
			fmt.Println(x)
		}
		return
	}
}
