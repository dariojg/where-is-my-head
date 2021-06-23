extends Node2D

onready var start_position = global_position
onready var target_position = global_position

onready var timer = $Timer

export var wander_range = 300

func _ready():
	update_target_position()

func update_target_position():
	#moves a random range around start position
	target_position = start_position + Vector2(rand_range(-wander_range, wander_range), rand_range(-wander_range, wander_range))
	
func _on_Timer_timeout():
	update_target_position()

func start_wander_time(duration):
	timer.start(duration)

func timer_time_left():
	return timer.time_left
