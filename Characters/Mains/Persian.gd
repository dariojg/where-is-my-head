extends "res://Characters/Character.gd"

onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var arrowSpawn = $ArrowSpawn

onready var animationTreeSwitcher = AnimationTreeSwitcher.new(animationTree)
onready var characterDetectionZone = $CharacterDetectionZone

var ArrowScene = preload("res://Proyectiles/Arrow.tscn")

func _ready():
	animationTree.active = true
	mode = Modes.FOLLOW

func _physics_process(delta):
	set_animation_state()
	if state == Global.States.DEAD:
		movement_vector = Vector2.ZERO
		return

	if mode == Modes.PROTECT:
		seek_character()
	
	set_state()
	
func seek_character():
		if characterDetectionZone.can_see_character():
			set_direction_to_attack()
			if state != Global.States.ATTACK:
				state = Global.States.ATTACK
		if state != Global.States.ATTACK:
			follow_companion()

func set_direction_to_attack():
	direction_vector = global_position.direction_to(characterDetectionZone.get_nearest_character(global_position).global_position)

func set_animation_state():
	animationTreeSwitcher.switch_animation(state, direction_vector)

func attack_animation_finished():
	shoot_arrow() #actually shoot arrow on animation finish
	state = Global.States.IDLE

func shoot_arrow():
	var arrow = ArrowScene.instance()
	arrow.position = position + direction_vector * 35 #35 = ancho/alto sprite~
	get_parent().add_child(arrow)
	arrow.rotation = direction_vector.angle()
	arrow.launch(direction_vector)
