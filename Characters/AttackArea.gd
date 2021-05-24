extends Position2D

var damage = 0
var knockback_vector = Vector2.ZERO

onready var HitAnimationPlayer = $HitAnimation/AnimationPlayer

func _on_Area2D_body_entered(body):
	if body.is_in_group("hurtable"):
		body.get_hurted(damage)
		body.knockback = knockback_vector * 150
		HitAnimationPlayer.stop()
		var anims = ["hit","hit2"]
		anims.shuffle()
		HitAnimationPlayer.play(anims.pop_front())
