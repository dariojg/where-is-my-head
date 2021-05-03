extends "res://Characters/Character.gd"

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var arrowSpawn = $ArrowSpawn

var ArrowScene = preload("res://Proyectiles/Arrow.tscn")

func _ready():
	animationTree.active = true

func set_animation_state():
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
	shoot_arrow() #actually shoot arrow on animation finish
	state = MOVE

func shoot_arrow():
	var arrow = ArrowScene.instance()
	arrow.position = position + direction_vector * 35 #35 = ancho/alto sprite~
	get_parent().add_child(arrow)
	arrow.rotation = direction_vector.angle()
	arrow.launch(direction_vector)
