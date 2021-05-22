extends KinematicBody2D

#Deberiamos implementar aceleración?
var speed = 400
var movement_vector = Vector2.ZERO
var direction_vector = Vector2(1,0)

var knockback = Vector2.ZERO
var knockback_vector = Vector2.ZERO

var state = Global.States.MOVE
var life = 100

func _physics_process(delta):
	set_animation_state(state)
	match state:
		Global.States.MOVE, Global.States.IDLE:
			get_input()
			move_and_slide(movement_vector * speed)

func get_input():
	#allows joystick input
	movement_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	movement_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	movement_vector = movement_vector.normalized()
	
	if movement_vector != Vector2.ZERO:
		direction_vector = movement_vector
		state = Global.States.MOVE
	else:
		state = Global.States.IDLE
	
	if Input.is_action_just_pressed("ui_attack") && state != Global.States.ATTACK:
		state = Global.States.ATTACK

func set_animation_state(state):
	pass
	
func get_hurted(damage_received):
	life -= damage_received
	if life <= 0:
		state = Global.States.DEAD
