extends Node2D

@export var components: Dictionary = {}
var gears: Dictionary = {}
var generators: Dictionary = {1:[10, 50], 2:[20, 100]}
#const OBJECTS = {0:"gear", 1:"testRotSource", 2:"testBigRotSource"}
@onready var player: CharacterBody2D = $"../Node2D/Player"
@onready var underground: TileMapLayer = $"../Node2D/Terrain/Underground"

func _process(delta: float) -> void:
	for componentCoords in components:
		var component = components[componentCoords]

		underground.set_cell(componentCoords, 0, Vector2i(1, component))
		
		if gears.has(componentCoords) and gears[componentCoords][2] == true:
			underground.set_cell(componentCoords, 0, Vector2i(0, component))

		if component == 0:
			#each gear has data of [speed, torque, active]
			gears[componentCoords] = [0, 0, false]

		if component == 1:
			var genInfo = generators[component]
			#each generator has data of [speed, torque], defined by its id
			for coords in findConnectedComponents(componentCoords):
				gears[coords] = [genInfo[0], genInfo[1], true]

func findConnectedComponents(startPoint: Vector2i) -> Array:
	var componentStack: Array = [startPoint]
	var resultStack = []
	var index = 0
	
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

func _input(event: InputEvent) -> void:
	var playerIntCoords: Vector2i = Vector2i(player.position) / 32

	if event.is_action_pressed("placeGear"):
		print(playerIntCoords, "placed Gear")
		components[playerIntCoords] = 0
	if event.is_action_pressed("placeTestGen"):
		print(playerIntCoords, "placed Gen")
		components[playerIntCoords] = 1
