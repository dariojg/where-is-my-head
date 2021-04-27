extends KinematicBody2D

#Deberiamos implementar aceleración?
var speed = 300
var movement_vector = Vector2.ZERO
var direction_vector = Vector2(0, 1)
onready var AnimatedSprite = $AnimatedSprite

enum {
	MOVE,
	ATTACK,
}

var state = MOVE

func _ready():
	$AnimatedSprite.playing = true

func _physics_process(delta):
	match state:
		MOVE:
			movement_state()
			move_and_slide(movement_vector * speed)
			get_movement_animation()
			
		ATTACK:
			attack_state()

func movement_state():
	#allows joystick input
	movement_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	movement_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	movement_vector = movement_vector.normalized()
	
	if movement_vector != Vector2.ZERO:
		direction_vector = movement_vector
	
	if Input.is_action_just_pressed("ui_attack"):
		state = ATTACK

func get_movement_animation():
	var animation_name = get_animation_name_from_direction(movement_vector) 
	animation_name = 'idle' if animation_name == null else animation_name		
		
	AnimatedSprite.animation = animation_name

func get_animation_name_from_direction(vector):
	var animation_name
	if vector.y != 0 && vector.x != 0:
		animation_name = "up-right" if vector.y < 0 else "down-right"
	else:
		if vector.x != 0:
			animation_name = "right"		
		if vector.y != 0:
			animation_name = "up" if vector.y < 0 else "down"
	
	if vector.x > 0:
		AnimatedSprite.flip_h = false
	else:
		AnimatedSprite.flip_h = true
	return animation_name

func attack_state():
	var animation_name = get_animation_name_from_direction(direction_vector)
	animation_name = 'attack-'+ animation_name
	AnimatedSprite.play(animation_name)

#Rustic?
func _on_AnimatedSprite_animation_finished():
	if AnimatedSprite.animation.begins_with("attack"):
		state = MOVE
