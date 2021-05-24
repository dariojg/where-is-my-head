extends Area2D

var launched = false
export var velocity = Vector2(0, 0)
var speed = 500
var time_to_live = 10 #10 segs
var knockback_power = 80
var knockback_direction = Vector2.ZERO
onready var HitAnimationPlayer = $HitAnimation/AnimationPlayer
onready var Sprite = $Sprite

var damage = 20

func _physics_process(delta):
	if launched:
		position += velocity * delta
		time_to_live -= delta
	
	if time_to_live <= 0:
		queue_free()

func launch(initial_velocity : Vector2):
	launched = true
	knockback_direction = initial_velocity
	velocity = initial_velocity * speed
	Sprite.visible = true

func _on_Arrow_body_entered(body):
	velocity = Vector2.ZERO
	if body.is_in_group("hurtable"):
		body.get_hurted(damage)
		body.knockback = knockback_direction * knockback_power
		HitAnimationPlayer.stop()
		var anims = ["hit","hit2"]
		anims.shuffle()
		HitAnimationPlayer.play(anims.pop_front())
	else:
		queue_free()
