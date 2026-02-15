extends Node

var turn := 1

func next_turn():
	turn += 1
	print("Turn advanced to:", turn)

func reset():
	turn = 1
