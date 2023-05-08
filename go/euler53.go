package main
import "fmt"
const limit_in = 100
const limit_out = 1_000_000

func main() {
	var c int
	for r := 1; r < limit_in; r++ {
		var x, y int = 0, 1
		for n := r+1; n <= limit_in; n++ {
			x++
			y *= n
			y /= x
			if y > limit_out {
				c += limit_in - n + 1
				break
			}
		}
	}
	fmt.Println("Results:", c)
}
