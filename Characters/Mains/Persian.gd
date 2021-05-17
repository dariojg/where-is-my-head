extends "res://Characters/Character.gd"

onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var arrowSpawn = $ArrowSpawn

onready var animationTreeSwitcher = AnimationTreeSwitcher.new(animationTree)

var ArrowScene = preload("res://Proyectiles/Arrow.tscn")

func _ready():
	animationTree.active = true

func set_animation_state(state):
	animationTreeSwitcher.switch_animation(state, movement_vector)

func attack_animation_finished():
	shoot_arrow() #actually shoot arrow on animation finish
	state = Global.States.MOVE

func shoot_arrow():
	var arrow = ArrowScene.instance()
	arrow.position = position + direction_vector * 35 #35 = ancho/alto sprite~
	get_parent().add_child(arrow)
	arrow.rotation = direction_vector.angle()
	arrow.launch(direction_vector)
