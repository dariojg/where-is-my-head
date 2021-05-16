extends KinematicBody2D

#Deberiamos implementar aceleración?
var speed = 400
var movement_vector = Vector2.ZERO
var direction_vector = Vector2(1,0)

var knockback = Vector2.ZERO
var knockback_vector = Vector2.ZERO

enum {
	MOVE,
	ATTACK,
}

var state = MOVE
var life = 100

func _physics_process(delta):
	match state:
		MOVE:
			get_input()
			set_animation_state()
			move_and_slide(movement_vector * speed)
			
		ATTACK:
			attack()
			
func get_input():
	#allows joystick input
	movement_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	movement_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	movement_vector = movement_vector.normalized()
	
	if movement_vector != Vector2.ZERO:
		direction_vector = movement_vector
	
	if Input.is_action_just_pressed("ui_attack"):
		state = ATTACK
		
func attack():
	pass
	
func set_animation_state():
	pass
	
func get_hurted(damage_received):
	life -= damage_received
	if life <= 0:
		queue_free()
