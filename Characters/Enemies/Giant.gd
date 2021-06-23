extends KinematicBody2D

var life = 100
var damage = 10

#var cooldown #TODO implementar

onready var animationTree = $AnimationTree
onready var attackRange = $AttackRange
onready var characterDetectionZone = $CharacterDetectionZone
onready var wanderController = $WanderController
onready var animationTreeSwitcher = AnimationTreeSwitcher.new(animationTree)

var state = Global.States.IDLE
var speed = 100
var velocity = Vector2.ZERO

var knockback = Vector2.ZERO
var friction = 200

func _ready():
	animationTree.active = true
	$AttackArea.damage = self.damage
	state = pick_random_state([Global.States.IDLE, Global.States.WANDER])

func _physics_process(delta):
	set_animation_state()
	if state != Global.States.DEAD:
		knockback = knockback.move_toward(Vector2.ZERO, friction * delta)
		knockback = move_and_slide(knockback)

	match state:
		Global.States.IDLE:
			velocity = Vector2.ZERO
			seek_and_wander()

		Global.States.WANDER:
			seek_and_wander()
			velocity = global_position.direction_to(wanderController.target_position)			

			if global_position.distance_to(wanderController.target_position) <= 5:
				pick_random_state_and_reset_wander()
			move_and_slide(velocity * speed)

		Global.States.CHASE:
			var character = characterDetectionZone.get_nearest_character(global_position)
			if character != null:
				velocity = global_position.direction_to(character.global_position)
				if attackRange.is_colliding():
					state = Global.States.ATTACK
				else:
					move_and_slide(velocity * speed)

			else:
				state = Global.States.IDLE

func set_animation_state():
	animationTreeSwitcher.switch_animation(state, velocity)
	if state in [Global.States.WANDER,Global.States.CHASE]:
		attackRange.cast_to = velocity * 43

func get_hurted(damage_received):
	life -= damage_received
	if life <= 0:
		state = Global.States.DEAD

func seek_character():
	if characterDetectionZone.can_see_character():
		state = Global.States.CHASE

func seek_and_wander():
	seek_character()
	if wanderController.timer_time_left() == 0:
		pick_random_state_and_reset_wander()

func pick_random_state_and_reset_wander():
		state = pick_random_state([Global.States.IDLE, Global.States.WANDER])
		wanderController.start_wander_time(rand_range(1,3))

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func attack_animation_finished():
	state = Global.States.CHASE
