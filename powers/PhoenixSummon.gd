extends Node2D

export (PackedScene) var phoenixScene

onready var phoenixSpawnTimer = $PhoenixSpawnTimer

export var duration = 10 #segs
var time_left = 0
var wait_fireball_spawn = 3

export var cooldown_total = 5 #segs
var cooldown = 0

func _get_camera_center():
	var vtrans = get_canvas_transform()
	var top_left = -vtrans.get_origin() / vtrans.get_scale()
	var vsize = get_viewport_rect().size
	return top_left + 0.5*vsize/vtrans.get_scale()

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
	var viewport = get_viewport() #delete
	var visiblerect = get_viewport().get_visible_rect() #delete
	var camera_center = _get_camera_center()
	var visible_size = get_viewport().get_visible_rect().size
	var xLeft = camera_center.x - visible_size.x/2
	var xRight = camera_center.x + visible_size.x/2
	var yUp = camera_center.y - visible_size.y/2
	var yDown = camera_center.y + visible_size.y/2
	var randX = rand_range(xLeft,  xRight)
	var randY = rand_range(yUp, yDown)
	var posiblePositions = [Vector2(xLeft,randY),
	Vector2(randX, yUp),
	Vector2(xRight,randY),
	Vector2(randX, yDown)]
	posiblePositions.shuffle()
	phoenix.position = posiblePositions.pop_front()
	var direction = Vector2(1 if phoenix.position.x <= camera_center.x else -1, 1 if phoenix.position.y <= camera_center.y else -1) 
	get_parent().add_child(phoenix)
	phoenix.launch(direction)

func _on_PhoenixSpawnTimer_timeout():
	summon_phoenix()
