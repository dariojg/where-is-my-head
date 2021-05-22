extends "res://Characters/Character.gd"

onready var animationTree = $AnimationTree
onready var attackArea = $AttackArea

onready var animationTreeSwitcher = AnimationTreeSwitcher.new(animationTree)

export var damage = 50

func _ready():
	attackArea.damage = self.damage

func _physics_process(delta):
	attackArea.knockback_vector = direction_vector

func set_animation_state(state):
	animationTreeSwitcher.switch_animation(state, movement_vector)

func attack_animation_finished():
	state = Global.States.IDLE
