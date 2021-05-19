extends Sprite

onready var impactArea = $ImpactArea/CollisionShape2D
onready var animationPlayer = $AnimationPlayer
export var damage = 200

func launch():
	animationPlayer.play("fall")

func _on_ImpactArea_body_entered(body):
	if body.is_in_group("hurtable"):
		body.get_hurted(damage)
