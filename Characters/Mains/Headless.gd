extends "res://Characters/Character.gd"

onready var animationTree = $AnimationTree
onready var attackArea = $AttackArea

onready var animationTreeSwitcher = AnimationTreeSwitcher.new(animationTree)
onready var characterDetectionZone = $CharacterDetectionZone
onready var attackRange = $AttackRange

export var damage = 50

func _ready():
	animationTree.active = true
	attackArea.damage = self.damage

func _physics_process(delta):
	set_animation_state()

	if state == Global.States.DEAD:
		movement_vector = Vector2.ZERO
		return
		
	if mode == Modes.PROTECT:
		if state != Global.States.CHASE && state != Global.States.ATTACK:
			seek_character()
		else:
			var character = characterDetectionZone.get_nearest_character(global_position)
			if character != null:
				movement_vector = global_position.direction_to(character.global_position)
				if attackRange.is_colliding():
					state = Global.States.ATTACK
				else:
					move_and_slide(movement_vector * speed)

			else:
				state = Global.States.IDLE

	set_state()
	attackArea.knockback_vector = direction_vector

func set_animation_state():
	animationTreeSwitcher.switch_animation(state, movement_vector)
	if state == Global.States.CHASE:
		attackRange.cast_to = movement_vector * 45

func attack_animation_finished():
	state = Global.States.IDLE

func seek_character():
	if characterDetectionZone.can_see_character():
		state = Global.States.CHASE
	else:
		if state != Global.States.ATTACK:
			follow_companion()
