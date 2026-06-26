extends Node

@export var base_health_copy: int = 9999
@export var game_end: bool = false

func lose():
	game_end = true
	base_health_copy = 0
	print("lose")
	
func win():
	game_end = true
	print("win")

func _process(delta: float) -> void:
	if base_health_copy <= 0 and not game_end:
		lose()
func _ready() -> void:
	%GearManager.placeTestGen(Vector2i(5, -7), 1)
