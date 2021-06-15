extends KinematicBody2D

#Deberiamos implementar aceleración?
var speed = 400
var movement_vector = Vector2.ZERO
var direction_vector = Vector2(1,0)

var knockback = Vector2.ZERO
var knockback_vector = Vector2.ZERO

var state = Global.States.MOVE
var life = 100

onready var Camera = $Camera2D

var companion 

#Modos manejo Manual, seguir o protejer/atacar enemigos a la vista
enum Modes {
	MANUAL,
	FOLLOW,
	PROTECT
}

var mode = Modes.MANUAL

func _physics_process(delta):
	set_animation_state(state)
	
	match mode:
		Modes.MANUAL:
			match state:
				Global.States.MOVE, Global.States.IDLE:
					movement_vector = get_manual_movement_vector()
					move_and_slide(movement_vector * speed)

		Modes.FOLLOW:
			var companion_position = companion.global_position
			movement_vector = global_position.direction_to(companion_position)
			if global_position.distance_to(companion_position) > 150:
				move_and_slide(movement_vector * speed) #*0.8? el compañero se mueve mas lento?
			else:
				movement_vector = Vector2.ZERO

		Modes.PROTECT:
			pass
			
	if Input.is_action_just_pressed("switch_character"):
		if mode in [Modes.FOLLOW, Modes.PROTECT]:
			mode = Modes.MANUAL
			self.Camera.current = true
		else:
			mode = Modes.FOLLOW
			self.Camera.current = false

	set_state()

	if mode != Modes.MANUAL && Input.is_action_just_pressed("switch_companion_mode"):
		mode = Modes.FOLLOW if mode == Modes.PROTECT else Modes.PROTECT


func set_state():	
	if state != Global.States.ATTACK && state != Global.States.DEAD: #quizas esto no vaya aca
		if movement_vector != Vector2.ZERO:
			direction_vector = movement_vector
			state = Global.States.MOVE
		else:
			state = Global.States.IDLE

	if mode == Modes.MANUAL && state != Global.States.ATTACK && Input.is_action_just_pressed("ui_attack"):	
		state = Global.States.ATTACK

func set_animation_state(new_state):
	pass
	
func get_hurted(damage_received):
	life -= damage_received
	if life <= 0:
		state = Global.States.DEAD

func set_companion(character):
	companion = character

func get_manual_movement_vector():
	#allows joystick input
	var movement_vector = Vector2.ZERO
	movement_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	movement_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	return movement_vector.normalized()
