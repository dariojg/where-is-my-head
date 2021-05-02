extends Area2D

var launched = false
var velocity = Vector2(0, 0)
var speed = 500

var damage = 20

func _process(delta):	
	if launched:
		position += velocity*delta
		#TODO darle un TTL para que no viva infinitamente

func launch(initial_velocity : Vector2):
	launched = true
	velocity = initial_velocity * speed

func _on_Proyectile2_body_entered(body):
	if body.is_in_group('mobiles'):
		body.receive_damage(damage)
		queue_free()
	if body.is_in_group('walls'):
		queue_free()
