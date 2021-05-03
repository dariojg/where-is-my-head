extends "res://Characters/Character.gd"

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

var damage = 50

func _ready():
	animationTree.active = true

func _physics_process(delta):
	if movement_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", movement_vector)
		animationTree.set("parameters/Move/blend_position", movement_vector)
		animationTree.set("parameters/Attack/blend_position", movement_vector)
		animationState.travel("Move")
	else:
		animationState.travel("Idle")

func attack():
	animationState.travel("Attack")
	
func attack_animation_finished():
	state = MOVE

func _on_Area2D_body_entered(body):
	body.get_hurted(damage)
