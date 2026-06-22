extends Node2D

var components: Dictionary[Vector2i,Component] = {}
var gears: Dictionary = {}
var generators: Dictionary = {}
var genInfo: Dictionary = {1:{"speed":10, "torque":50}, 2:{"speed":20, "torque":100}}
@onready var player: CharacterBody2D = $"../Node2D/Player"
@onready var underground: TileMapLayer = $"../Node2D/Terrain/Underground"

class Component:
	var size: int = 32
	var speed: int = 0
	var torque: int = 0
	var isGenerator: bool = false
	
	func _init(siz, spee, torqu, isGenerato) -> void:
		self.size = siz
		self.speed = spee
		self.torque = torqu
		self.isGenerator = isGenerato

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass

func findConnectedComponents(startPoint: Vector2i) -> Array:
	var componentStack: Array[Vector2i] = [startPoint]
	var index: int = 0
	
	while componentStack.size() > index:
		var node: Vector2i = componentStack.pop_front()

		if components.has(node + Vector2i.UP) and (node + Vector2i.UP) not in componentStack:
			componentStack.append(node + Vector2i.UP)
		if components.has(node + Vector2i.RIGHT) and (node + Vector2i.UP) not in componentStack:
			componentStack.append(node + Vector2i.RIGHT)
		if components.has(node + Vector2i.DOWN) and (node + Vector2i.UP) not in componentStack:
			componentStack.append(node + Vector2i.DOWN)
		if components.has(node + Vector2i.LEFT) and (node + Vector2i.UP) not in componentStack:
			componentStack.append(node + Vector2i.LEFT)
		
		print(componentStack)
		index += 1
	return componentStack

func _input(event: InputEvent) -> void:
	var playerTilemapCoords: Vector2i = underground.local_to_map(player.position)

	if event.is_action_pressed("placeGear"):
		print(playerTilemapCoords, "placed Gear")
		#components[playerTilemapCoords] = 0
		gears[playerTilemapCoords] = [0, 0, false]
		updateGearRendering()
	if event.is_action_pressed("placeTestGen"):
		print(playerTilemapCoords, "placed Gen")
		#components[playerTilemapCoords] = 1
		
		updateGearRendering()
		#updateGearLogic()

func updateGearRendering() -> void:
	for gearCoords in gears:
		underground.set_cell(gearCoords, 0, Vector2i(0, 0))
		
		if gears.has(gearCoords) and gears[gearCoords][2] == true:
			underground.set_cell(gearCoords, 0, Vector2i(1, 0))

#func updateGearLogic() -> void:
	#for componentCoords in components:
		#var component = components[componentCoords]
#
		#for coords in findConnectedComponents(componentCoords):
			#gears[coords] = [genInfo[0], genInfo[1], true]
