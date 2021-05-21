extends Node2D

export (PackedScene) var phoenixScene

onready var phoenixSpawnTimer = $PhoenixSpawnTimer

export var duration = 10 #segs
var time_left = 0
var wait_fireball_spawn = 3

export var cooldown_total = 120 #segs
var cooldown = 0

func activate():
	if cooldown <= 0: #check for cooldown just in case
		time_left = duration
		phoenixSpawnTimer.start()
		cooldown = cooldown_total

func _physics_process(delta):
	if Input.is_action_just_pressed("phoenix_summon"):
		activate()
	
	if cooldown > 0:
		cooldown -= delta
	if time_left > 0:
		time_left -= delta
	else:
		phoenixSpawnTimer.stop()

func summon_phoenix():
	var phoenix = phoenixScene.instance()
	var visible_size = get_viewport().get_visible_rect().size
	var randX = rand_range(0, visible_size.x)
	var randY = rand_range(0, visible_size.y)
	var posiblePositions = [Vector2(0,randY),
	Vector2(randX, 0),
	Vector2(visible_size.x,randY),
	Vector2(randX, visible_size.y)]
	posiblePositions.shuffle()
	phoenix.position = posiblePositions.pop_front()
	var direction = Vector2(1 if phoenix.position.x <= visible_size.x/2 else -1, 1 if phoenix.position.y <= visible_size.y/2 else -1) 
	get_parent().add_child(phoenix)
	phoenix.launch(direction)

func _on_PhoenixSpawnTimer_timeout():
	summon_phoenix()
