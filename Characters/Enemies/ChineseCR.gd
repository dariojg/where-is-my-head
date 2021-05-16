extends KinematicBody2D

var life = 100
var damage = 10

#var cooldown #TODO implementar

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var attackRange = $AttackRange
onready var playerDetectionZone = $PlayerDetectionZone
onready var wanderController = $WanderController

enum {
	IDLE,
	WANDER,
	CHASE,
	ATTACK
}

var state = IDLE
var speed = 100
var velocity = Vector2.ZERO

var knockback = Vector2.ZERO
#var knockback_vector = Vector2.ZERO
var friction = 200

func _ready():
	animationTree.active = true
	$AttackArea.damage = self.damage
	state = pick_random_state([IDLE, WANDER])
	
func _physics_process(delta):
	set_animation_state()
	
	knockback = knockback.move_toward(Vector2.ZERO, friction * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = Vector2.ZERO
			seek_and_wander()
		
		WANDER:
			seek_and_wander()
			velocity = global_position.direction_to(wanderController.target_position)			

			if global_position.distance_to(wanderController.target_position) <= 5:
				pick_random_state_and_reset_wander()
			move_and_slide(velocity * speed)
			
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				velocity = global_position.direction_to(player.global_position)
				if attackRange.is_colliding():
					state = ATTACK
				else:
					move_and_slide(velocity * speed)
				
			else:
				state = IDLE

func set_animation_state():
	match state:
		IDLE:
			animationState.travel("Idle")
		WANDER, CHASE:
			animationTree.set("parameters/Idle/blend_position", velocity)
			animationTree.set("parameters/Move/blend_position", velocity)
			animationTree.set("parameters/Attack/blend_position", velocity)
			animationState.travel("Move")	
			attackRange.cast_to = velocity * 43			
		ATTACK:
			animationState.travel("Attack")	
			
func get_hurted(damage_received):
	life -= damage_received
	if life <= 0:
		queue_free() #Actually animation.travel(death)

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func seek_and_wander():
	seek_player()
	if wanderController.timer_time_left() == 0:
		pick_random_state_and_reset_wander()

func pick_random_state_and_reset_wander():
		state = pick_random_state([IDLE, WANDER])
		wanderController.start_wander_time(rand_range(1,3))

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func attack_animation_finished():
	state = CHASE
