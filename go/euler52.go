package main
import ("github.com/juster/euler/go/euler"; "fmt")
const limit = 6

func main() {
	//seen := make(map[int]bool)
Loop:
	for a := 20; ; a++ {
		n := euler.DigitCount(a)
		for _, x := range n {
			if x > 1 {
				continue Loop
			}
		}
		var b int
		for c := 2; c < limit; c++ {
			b += a
			m := euler.DigitCount(b)
			for i, d := range m {
				if n[i] != d {
					continue Loop
				}
			}
		}
		var x int
		for i := 1; i <= 6; i++ {
			x += a
			fmt.Println(x)
		}
		return
	}
}
