extends Node2D

@export
var components = {}
const OBJECTS = {0:"gear", 1:"rotSource"}
@onready var underground: TileMapLayer = $"../Node2D/Terrain/Underground"

	
func _process(delta: float) -> void:
	for i in components:
		underground.set_cell(i, 0, Vector2i(1, components[i]))
