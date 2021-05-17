extends Node

enum States {
	MOVE,
	ATTACK,
	IDLE,
	WANDER,
	CHASE,
	DEAD
}

func _ready():
	randomize()
