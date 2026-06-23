extends Node2D

var components: Dictionary[Vector2i,Component] = {}
var generators: Array[Vector2i] = []
var gears: Array[Vector2i] = []
var genInfo: Dictionary = {1:{"speed":10, "torque":50}, 2:{"speed":20, "torque":100}}

##References to other objects
@onready var player: CharacterBody2D = $"../Node2D/Player"
@onready var underground: TileMapLayer = $"../Node2D/Terrain/Underground"

class Component: ##use visual speed when rendering components
	var size: int
	var speed: int
	var torque: int
	var firstCheck: bool
	var genID: int
	var visualSpeed: int

	func _init(siz = 32, spee = 0, torqu = 0, genI = 0) -> void:
		self.size = siz
		self.speed = spee
		self.torque = torqu
		self.genID = genI
		self.visualSpeed = self.speed
		if genID == 0:
			firstCheck = true

	func resetTo(siz = 32, spee = 0, torqu = 0, genI = 0, updateFirstCheck = true) -> void:
		self.size = siz
		self.speed = spee
		self.torque = torqu
		self.genID = genI
		self.visualSpeed = self.speed
		if genID == 0 and updateFirstCheck:
			firstCheck = true

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass

func findAndUpdateConnectedComponents(startPoint: Vector2i, genID: int) -> void: #TODO: add gear ratios/different gear sizes
	var componentStack: Array[Vector2i] = [startPoint]
	var index: int = 0
	
	while componentStack.size() > index:
		if components.has(componentStack[index] + Vector2i.RIGHT) and componentStack[index] + Vector2i.RIGHT not in componentStack:
			componentStack.insert(index + 1, componentStack[index] + Vector2i.RIGHT)
			updateComponent(componentStack[index] + Vector2i.RIGHT, genInfo[genID], startPoint)
		if components.has(componentStack[index] + Vector2i.DOWN) and componentStack[index] + Vector2i.DOWN not in componentStack:
			componentStack.insert(index + 1, componentStack[index] + Vector2i.DOWN)
			updateComponent(componentStack[index] + Vector2i.DOWN, genInfo[genID], startPoint)
		if components.has(componentStack[index] + Vector2i.LEFT) and componentStack[index] + Vector2i.LEFT not in componentStack:
			componentStack.insert(index + 1, componentStack[index] + Vector2i.LEFT)
			updateComponent(componentStack[index] + Vector2i.LEFT, genInfo[genID], startPoint)
		if components.has(componentStack[index] + Vector2i.UP) and componentStack[index] + Vector2i.UP not in componentStack:
			componentStack.insert(index + 1, componentStack[index] + Vector2i.UP)
			updateComponent(componentStack[index] + Vector2i.UP, genInfo[genID], startPoint)
		
		index += 1
	
func updateComponent(componentPos: Vector2i, currentGenInfo: Dictionary, currentGenPos: Vector2i) -> void:
	var component: Component = components[componentPos]
	var genSpeed: int = currentGenInfo["speed"]
	var genTorque: int = currentGenInfo["torque"]
	
	if component.genID == 0: #object is gear
		if component.firstCheck == true:
			component.resetTo(component.size, genSpeed, genTorque, 0, false)
			component.firstCheck = false
		else:
			component.resetTo(component.size, max(genSpeed, component.speed), genTorque + component.torque, 0, false)
	else: #object is other generator, update visual speed
		if component.speed > components[currentGenPos].speed:
			components[currentGenPos].visualSpeed = component.speed
		else:
			component.visualSpeed = components[currentGenPos].speed

func _input(event: InputEvent) -> void: ##method for placing test gear/generator
	var playerTilemapCoords: Vector2i = underground.local_to_map(player.position)

	if event.is_action_pressed("placeGear"): ##testing version of placing gear
		placeGear(playerTilemapCoords)

	if event.is_action_pressed("placeTestGen"):##testing version of placing generator
		placeTestGen(playerTilemapCoords)
		
	if event.is_action_pressed("Debug Tile Data"):
		printTileData(playerTilemapCoords)

func updateGearRendering() -> void:
	for componentCoords in components:
		var component: Component = components[componentCoords]
		
		
		if component.genID == 0 and component.speed != 0:
			underground.set_cell(componentCoords, 0, Vector2i(1, 0))
		else:
			underground.set_cell(componentCoords, 0, Vector2i(0, component.genID))

func updateGearLogic() -> void:
	for gearPos in gears:
		components[gearPos].firstCheck = true
	for genPos in generators:
		findAndUpdateConnectedComponents(genPos, components[genPos].genID)
	updateGearRendering()

func placeGear(playerTilemapCoords) -> void:
	if playerTilemapCoords in generators:
		generators.erase(playerTilemapCoords)
		gears.append(playerTilemapCoords)
		components[playerTilemapCoords].resetTo()
	elif playerTilemapCoords in components:
		gears.append(playerTilemapCoords)
		components[playerTilemapCoords].resetTo()
	else:
		gears.append(playerTilemapCoords)
		components[playerTilemapCoords] = Component.new()
	updateGearRendering()
	updateGearLogic()

func placeTestGen(playerTilemapCoords) -> void:
	if playerTilemapCoords in gears:
		gears.erase(playerTilemapCoords)
		generators.append(playerTilemapCoords)
		components[playerTilemapCoords].resetTo(32, 10, 50, 1)
	elif playerTilemapCoords in components:
		generators.append(playerTilemapCoords)
		components[playerTilemapCoords].resetTo(32, 10, 50, 1)
	else:
		generators.append(playerTilemapCoords)
		components[playerTilemapCoords] = Component.new(32, 10, 50, 1)
	
	updateGearRendering()
	updateGearLogic()

func printTileData(playerPos) -> void:
	if components.has(playerPos):
		print("Component: " + str(components[playerPos].genID))
		print("Speed: " + str(components[playerPos].speed) + " Visual Speed: " + str(components[playerPos].visualSpeed) + " Torque: " + str(components[playerPos].torque))
