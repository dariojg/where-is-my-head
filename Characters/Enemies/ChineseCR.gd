extends KinematicBody2D

var life = 100
var damage = 10

#var cooldown #TODO implementar

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var attackRange = $AttackRange

enum {
	IDLE,
	WANDER,
	CHASE,
	ATTACK
}

var state = IDLE
var speed = 100
var velocity = Vector2.ZERO

onready var PlayerDetectionZone = $PlayerDetectionZone

func _ready():
	animationTree.active = true
	$AttackArea.damage = self.damage
func _physics_process(delta):
	set_animation_state()
	
	match state:
		IDLE:
			velocity = Vector2.ZERO
			seek_player()
			
		WANDER:
			pass
			
		CHASE:
			var player = PlayerDetectionZone.player
			if player != null:
				velocity = (player.global_position - global_position).normalized()
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
	if PlayerDetectionZone.can_see_player():
		state = CHASE

func attack_animation_finished():
	state = CHASE
