package euler

type Sieve []bool

func (sieve Sieve) IsPrime(x int) bool {
	if x == 2 {
		return true
	}
	if x % 2 == 0 {
		return false
	}
	i := x / 2
	if i < 0 {
		return false
	}
	return sieve[i]
}

func (sieve Sieve) GenPrimes() <- chan int {
	return sieve.GenPrimesFrom(2)
}

func (sieve Sieve) GenPrimesFrom(min int) <-chan int {
	out := make(chan int)
	go func(){
		if min <= 2 {
			out <- 2
		}
		for i := min / 2; i < len(sieve); i++ {
			if sieve[i] {
				out <- 2 * i + 1
			}
		}
		close(out)
	}()
	return out
}

func (s Sieve) Primes() []int {
	var ps []int
	for i := range s.GenPrimes() {
		ps = append(ps, i)
	}
	return ps
}

func Eratosthenes(max int) Sieve {
	c := max / 2
	sieve := make([]bool, c + 1)
	sieve[0] = false // 1 is not prime
	for i := 1; i < c; i++ {
		sieve[i] = true
	}
	// sieve is only for odd numbers
	// i: 0 1 2 3 4
	// x: 1 3 5 7 9
	// x = 2i + 1
	// find index of multiple of 3
	// y = 3*x = 3*(2i + 1) = 6i + 3
	// y = 2j + 1
	// 6i + 3 = 2j + 1
	// j = (6i + 2) / 2 = 3i + 1
	// find index of multiple of 5
	// z = 5*x = 5*(2i + 1) = 10i + 5
	// z = 2k + 1
	// 10i + 5 = 2k + 1
	// k = (10i + 4) / 2 = 5i + 2
	for i := 1; i < c; i++ {
		if !sieve[i] {
			continue
		}
		j := 1
		for {
			// all multiples of number at i is not prime
			// but filter out the even multiples...
			k := (2 * j + 1) * i + j
			if k >= c {
				break
			}
			sieve[k] = false
			j++
		}
	}
	return sieve
}
