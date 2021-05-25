extends Area2D

var restorationAmount = randi()%40+20 #random entre 20 y 60

func _on_Item_body_entered(body):
	if "health" in body:
		body.health += restorationAmount
