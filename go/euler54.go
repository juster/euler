package main
import (
	"bufio"
	"fmt"
	"os"
	"sort"
	"strings"
)

type handName int16
type suite int8

const (
	per_suite = 14
	jack = 11
	queen = 12
	king = 13
	ace = 14
	club suite = iota
	spade
	diamond
	heart
	high_card handName = per_suite * iota
	one_pair
	two_pairs
	three_kind
	straight
	flush
	full_house
	four_kind
	straight_flush
	royal_flush
)

func (hn handName) String() string {
	switch hn {
	case high_card: return "high card"
	case one_pair: return "pair"
	case two_pairs: return "two pair"
	case three_kind: return "three of a kind"
	case straight: return "straight"
	case flush: return "flush"
	case full_house: return "full house"
	case four_kind: return "four of a kind"
	case straight_flush: return "straight flush"
	case royal_flush: return "royal flush"
	}
	return ""
}

type card struct {
	val int8
	sut suite
}

type hand []*card
type handScore struct {
	name handName
	high int8
}


func NewHand(codews string) (cards hand, err error) {
	flds := strings.Fields(codews)
	cards = make([]*card, len(flds))
	for i, code := range flds {
		cards[i], err = NewCard(code)
		if err != nil {
			cards = nil
			break
		}
	}
	return
}

func NewCard(codes string) (*card, error) {
	var v int8
	var s suite
	if len(codes) != 2 {
		return nil, fmt.Errorf("bad codes len: %s", codes)
	}
	if codes[0] >= '1' && codes[0] <= '9' {
		v = int8(codes[0] - '0')
	} else {
		switch codes[0] {
		case 'T': v = 10
		case 'J': v = 11
		case 'Q': v = 12
		case 'K': v = 13
		case 'A': v = 14
		default: return nil, fmt.Errorf("bad val: %s", codes)
		}
	}
	switch codes[1] {
		case 'C': s = club
		case 'S': s = spade
		case 'D': s = diamond
		case 'H': s = heart
		default: return nil, fmt.Errorf("bad suite: %s", codes)
	}
	return &card{val: v, sut: s}, nil
}

func NewScore(base handName, val int8) *handScore {
	return &handScore{base, val}
}

func (hs handScore) Beats(rhs handScore) bool {
	x := int16(hs.name) + int16(hs.high)
	y := int16(rhs.name) + int16(rhs.high)
	return (x > y)
}

func (hs handScore) String() string {
	return fmt.Sprintf("%s: %d", hs.name, hs.high)
}

func (c card) String() string {
	bs := make([]byte, 2)

	if c.val >= 1 && c.val <= 9 {
		bs[0] = '0' + byte(c.val)
	} else {
		switch c.val {
		case 10: bs[0] = 'T'
		case 11: bs[0] = 'J'
		case 12: bs[0] = 'Q'
		case 13: bs[0] = 'K'
		case 14: bs[0] = 'A'
		}
	}
	switch c.sut {
	case club: bs[1] = 'C'
	case spade: bs[1] = 'S'
	case diamond: bs[1] = 'D'
	case heart: bs[1] = 'H'
	}

	return string(bs)
}

// Methods to fulfill sort.Interface

func (h hand) Len() int {
	return len(h)
}

func (h hand) Less(i, j int) bool {
	return (h[i].val < h[j].val)
}

func (h hand) Swap(i, j int) {
	h[i], h[j] = h[j], h[i]
}

func (h hand) Sort() {
	sort.Sort(h)
}

func (h hand) isFlush() bool {
	suites := make(map[suite]int8)
	for _, c := range h {
		suites[c.sut]++
	}
	for _, n := range suites {
		if int(n) == len(h) { return true }
	}
	return false
}

func (h hand) isStraight() bool {
	x := h[0].val
	// special case: ace can have value 1 for straights
	if x == ace && h[1].val == 2 {
		x = 1
	}
	for i := 1; i < len(h); i++ {
		y := h[i].val
		if x+1 != y {
			return false
		}
		x = y
	}
	return true
}

func (h hand) Score() *handScore {
	h.Sort()
	vals := make(map[int8]int8)
	for _, c := range h {
		vals[c.val]++
	}
	var val2, val3, val4 int8
	for v, n := range vals {
		switch n {
		case 4: val4 = v
		case 3: val3 = v
		case 2: val2 = v
		}
	}
	is_straight, is_flush := h.isStraight(), h.isFlush()
	hival := h[len(h)-1].val

	switch {
	case is_flush && is_straight:
		if h[0].val == 10 {
			return NewScore(royal_flush, hival)
		}
		return NewScore(straight_flush, hival)
	case val4 > 0:
		return NewScore(four_kind, val4)
	case val2 > 0 && val3 > 0:
		return NewScore(full_house, val3)
	case is_flush:
		return NewScore(flush, hival)
	case is_straight:
		return NewScore(straight, hival)
	case val3 > 0:
		return NewScore(three_kind, val3)
	case val2 > 0:
		counts := make(map[int8]int8)
		max := make(map[int8]int8)
		for v, n := range vals {
			counts[n]++
			if max[n] < v {
				max[n] = v
			}
		}

		switch counts[2] {
		case 2:
			return NewScore(two_pairs, max[2])
		case 1:
			return NewScore(one_pair, val2)
		}
	}

	return NewScore(high_card, hival)
}

func (lh hand) Beats(rh hand) bool {
	return lh.Score().Beats(*rh.Score())
}

func (h hand) String() string {
	cards := make([]string, len(h))
	for i, c := range(h) {
		cards[i] = c.String()
	}
	return strings.Join(cards, " ")
}

func main() {
	var wins1 int
	var err error
	scanner := bufio.NewScanner(os.Stdin)
	for scanner.Scan() {
		line := scanner.Text()
		flds := strings.Fields(line)
		if len(flds) != 10 {
			panic("expected 10 cards")
		}
		h1 := make(hand, 5)
		h2 := make(hand, 5)

		for i, str := range flds[0:5] {
			h1[i], _ = NewCard(str)
		}
		for i, str := range flds[5:] {
			h2[i], _ = NewCard(str)
		}

		//var wins string
		score1, score2 := h1.Score(), h2.Score()
		if score1.Beats(*score2) {
			wins1++
			//wins = "PLAYER1"
		} else {
			//wins = "PLAYER2"
		}
		//fmt.Printf("%s %s (%s) %s (%s)\n", wins, h1, score1, h2, score2)
	}
	if err = scanner.Err(); err != nil {
		fmt.Fprintf(os.Stderr, "stdin error: %v\n", err)
		os.Exit(1)
	}
	fmt.Println("Result:", wins1)
}
