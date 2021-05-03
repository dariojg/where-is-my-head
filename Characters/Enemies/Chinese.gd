extends KinematicBody2D

var life = 100

func get_hurted(damage):
	life -= damage
	if life <= 0:
		queue_free() #Actually animation.travel(death)
