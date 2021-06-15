extends Area2D

var characters = []

func can_see_character():
	return !characters.empty()

func get_nearest_character(position):
	if characters.empty():
		return null
	var closer_character = characters[0]
	for character in characters:
		if position.distance_to(character.global_position) < position.distance_to(closer_character.global_position):
			closer_character = character
	return closer_character

func _on_CharacterDetectionZone_body_entered(body):
	characters.push_back(body)

func _on_CharacterDetectionZone_body_exited(body):
	characters.remove(characters.find(body))
