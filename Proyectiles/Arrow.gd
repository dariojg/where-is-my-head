extends Area2D

var launched = false
var velocity = Vector2(0, 0)
var speed = 500
var time_to_live = 10 #10 segs

var knockback = Vector2.ZERO

var damage = 20

func _physics_process(delta):
	if launched:
		position += velocity * delta
		time_to_live -= delta
	
	if time_to_live <= 0:
		queue_free()

func launch(initial_velocity : Vector2):
	launched = true
	knockback = initial_velocity
	velocity = initial_velocity * speed

func _on_Arrow_body_entered(body):
	if body.is_in_group("hurtable"):
		body.get_hurted(damage)
		body.knockback = knockback * 80
	queue_free()
