package main

import "fmt"

const limit = 9

var max = 0

func main() {
	buf := make([]byte, 0, 9)
	for i := 2; i <= limit; i++ {
		for j := 1; j <= 9; j++ {
			prod := fmt.Sprintf("%d", i * j)
			if len(buf) + len(prod) > 9 {
				continue
			}
			buf = append(buf, []byte(prod)...)
			if len(buf) == 9 && isPandigital(buf) {
				var x int
				if fmt.Sscanf(string(buf), "%d", &x); x > max {
					max = x
				}
				fmt.Printf("%d x (1, %d) = %s\n", i, j, buf)
			}
		}
		buf = buf[0:0]
	}
	fmt.Printf("Results: %d\n", max)
}

func isPandigital(slice []byte) bool {
	set := make(map[int]bool)
	for b := range slice {
		if _, ok := set[b]; ok {
			return false
		}
		set[b] = true
	}
	return (len(set) == 9)
}
