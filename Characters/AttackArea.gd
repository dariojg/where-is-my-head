extends Position2D

var damage = 0

func _on_Area2D_body_entered(body):
	body.get_hurted(damage)
