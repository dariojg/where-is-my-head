extends Node2D

onready var Headless = $Headless
onready var Persian = $Persian

func _ready():
	Headless.set_companion(Persian)
	Persian.set_companion(Headless)	
