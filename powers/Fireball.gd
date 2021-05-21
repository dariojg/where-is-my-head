extends Sprite

onready var impactArea = $ImpactArea/CollisionShape2D
onready var animationPlayer = $AnimationPlayer
export var damage = 200

var direction_vector = Vector2.ZERO
var launched = false
var speed = 100

func _physics_process(delta):
	if launched:
		position += direction_vector * speed * delta

func launch():
	animationPlayer.play("fall")
	launched = true
	direction_vector = Vector2(cos(rotation), sin(rotation))
	rotation -= PI/4 #damn rotated sprite

func _on_ImpactArea_body_entered(body):
	if body.is_in_group("hurtable"):
		body.get_hurted(damage)

func explode():
	animationPlayer.play("explode")
	direction_vector = Vector2.ZERO
