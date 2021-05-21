extends Node2D

var direction_vector = Vector2.ZERO
export var speed = 150

export (PackedScene) var fireballScene

onready var fireballSpawnTimer = $FireballSpawnTimer
onready var AnimationPlayer = $AnimationPlayer

func launch(direction):
	direction_vector = direction
	if direction == Vector2(1,1):
		AnimationPlayer.play("down-right")
	if direction == Vector2(1,-1):
		AnimationPlayer.play("up-right")
	if direction == Vector2(-1,1):
		AnimationPlayer.play("down-left")
	if direction == Vector2(-1,-1):
		AnimationPlayer.play("up-left")
	fireballSpawnTimer.start()
	
func _physics_process(delta):
	position += direction_vector * speed * delta

func summon_fireball():
	var fireball = fireballScene.instance()
	fireball.position = position
	fireball.rotation = direction_vector.angle() + rand_range(-PI/4,PI/4)
	get_parent().add_child(fireball)
	fireball.launch()

func _on_FireballSpawnTimer_timeout():
	summon_fireball()
