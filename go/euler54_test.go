package main

import (
	"testing"
)

type handCase struct {
	input string;
	score handScore;
}

var handTestCases = []handCase{
	{
		"8C 8S 8H 8D 4S",
		MakeScore(four_kind, 8),
	},
	{
		"TC JC QC KC AC",
		MakeScore(royal_flush, ace),
	},
	{
		"2C 8C TC AC 6C",
		MakeScore(flush, ace),
	},
}

func TestCardHands(t *testing.T) {
	for _, tc := range handTestCases {
		h, err := NewHand(tc.input)
		if err != nil {
			panic(err)
		}
		if h.Score() != tc.score {
			t.Fatalf("expected score: %v got score %v", tc.score, h.Score())
		}
	}
}
