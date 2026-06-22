extends Node2D

@export
var components = {}
const OBJECTS = {0:"gear", 1:"testRotSource"}
@onready var underground: TileMapLayer = $"../Node2D/Terrain/Underground"

	
func _process(delta: float) -> void:
	for i in components:
		underground.set_cell(i, 0, Vector2i(1, components[i]))
		if components[i] == 1:
			findConnectedComponents(i)
		
		
func findConnectedComponents(Vector2i) -> void:
	var componentStack = []
	while componentStack:
		var node = componentStack.pop_front()
		if components[node + Vector2i.UP]:
			componentStack.append(node + Vector2i.UP)
		if components[node + Vector2i.UP]:
			componentStack.append(node + Vector2i.RIGHT)
		if components[node + Vector2i.UP]:
			componentStack.append(node + Vector2i.DOWN)
		if components[node + Vector2i.UP]:
			componentStack.append(node + Vector2i.LEFT)
