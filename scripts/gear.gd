extends Node2D

@export
var components = {}
var gears = {}
var generators = {1:[10, 50], 2:[20, 100]}
#const OBJECTS = {0:"gear", 1:"testRotSource", 2:"testBigRotSource"}
@onready var underground: TileMapLayer = $"../Node2D/Terrain/Underground"

	
func _process(delta: float) -> void:
	for componentCoords in components:
		underground.set_cell(componentCoords, 0, Vector2i(1, components[componentCoords]))
		
		if components[componentCoords] == 0:
			#each gear has data of [speed, torque, active]
			gears[componentCoords] = [0, 0, false]
		
		if components[componentCoords] == 1:
			var genInfo = generators[componentCoords]
			#each generator has data of [speed, torque], defined by its id
			for coords in findConnectedComponents(componentCoords):
				gears[coords] = [genInfo[0], genInfo[1], true]
			
func findConnectedComponents(startPoint: Vector2i) -> ItemList:
	var componentStack = [startPoint]
	var resultStack = []
	
	while componentStack:
		var node = componentStack.pop_front()
		
		if components.has(node + Vector2i.UP):
			componentStack.append(node + Vector2i.UP)
			resultStack.append(componentStack[-1])
		if components.has(node + Vector2i.RIGHT):
			componentStack.append(node + Vector2i.RIGHT)
			resultStack.append(componentStack[-1])
		if components.has(node + Vector2i.DOWN):
			componentStack.append(node + Vector2i.DOWN)
			resultStack.append(componentStack[-1])
		if components.has(node + Vector2i.LEFT):
			componentStack.append(node + Vector2i.LEFT)
			resultStack.append(componentStack[-1])
			
	return resultStack
