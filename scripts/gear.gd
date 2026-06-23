extends Node2D

var components: Dictionary[Vector2i,Component] = {}
var generators: Array[Vector2i] = []
var genInfo: Dictionary = {1:{"speed":10, "torque":50}, 2:{"speed":20, "torque":100}}

##References to other objects
@onready var player: CharacterBody2D = $"../Node2D/Player"
@onready var underground: TileMapLayer = $"../Node2D/Terrain/Underground"

class Component:
	var size: int
	var speed: int
	var torque: int
	var firstCheck: bool
	var genID: int

	func _init(siz = 32, spee = 0, torqu = 0, genI = 0) -> void:
		self.size = siz
		self.speed = spee
		self.torque = torqu
		self.genID = genI
		if genID == 0:
			firstCheck == true

	func resetTo(siz = 32, spee = 0, torqu = 0, genI = 0) -> void:
		self.size = siz
		self.speed = spee
		self.torque = torqu
		self.genID = genI
		if genID == 0:
			firstCheck == true


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass

func findConnectedComponents(startPoint: Vector2i) -> Array: #TODO: make this better/integrate this better
	var componentStack: Array[Vector2i] = [startPoint]
	var index: int = 0
	
	while componentStack.size() >= index:
		var node: Vector2i = componentStack.pop_front()

		if components.has(node + Vector2i.UP) and (node + Vector2i.UP) not in componentStack:
			componentStack.append(node + Vector2i.UP)
		if components.has(node + Vector2i.RIGHT) and (node + Vector2i.UP) not in componentStack:
			componentStack.append(node + Vector2i.RIGHT)
		if components.has(node + Vector2i.DOWN) and (node + Vector2i.UP) not in componentStack:
			componentStack.append(node + Vector2i.DOWN)
		if components.has(node + Vector2i.LEFT) and (node + Vector2i.UP) not in componentStack:
			componentStack.append(node + Vector2i.LEFT)
		
		index += 1
	return componentStack

func _input(event: InputEvent) -> void:
	var playerTilemapCoords: Vector2i = underground.local_to_map(player.position)

	if event.is_action_pressed("placeGear"): ##testing version of placing gear
		if playerTilemapCoords in generators:
			generators.erase(playerTilemapCoords)
			components[playerTilemapCoords].resetTo()
		elif playerTilemapCoords in components:
			components[playerTilemapCoords].resetTo()
		else:
			components[playerTilemapCoords] = Component.new()
		updateGearRendering()
	
	if event.is_action_pressed("placeTestGen"):##testing version of placing generator
		if playerTilemapCoords in components:
			components[playerTilemapCoords].resetTo(32, 10, 50, 1)
			generators.append(playerTilemapCoords)
		else:
			components[playerTilemapCoords] = Component.new(32, 10, 50, 1)
			generators.append(playerTilemapCoords)
		
		updateGearRendering()
		#updateGearLogic()

func updateGearRendering() -> void:
	for componentCoords in components:
		var component: Component = components[componentCoords]
		underground.set_cell(componentCoords, 0, Vector2i(0, component.genID))
		
		if component.genID == 0 and component.speed != 0:
			underground.set_cell(componentCoords, 0, Vector2i(1, 0))

#func updateGearLogic() -> void: ##TODO: This
	#for componentCoords in components:
		#var component = components[componentCoords]
#
		#for coords in findConnectedComponents(componentCoords):
			#gears[coords] = [genInfo[0], genInfo[1], true]

func updateGearLogic() -> void:
	pass
