extends Node

var components: Dictionary[Vector2i,Component] = {}
var generators: Array[Vector2i] = []
var gears: Array[Vector2i] = []
var genInfo: Dictionary = {1:{"speed":5, "torque":50}, 2:{"speed":10, "torque":200}, 3:{"speed":20, "torque":500}}

@onready var player: CharacterBody2D = $"../Node2D/Player"
@onready var componentMap: TileMapLayer = $"../Node2D/Terrain/GearAndGenMap"
@onready var groundMap: TileMapLayer = %Ground

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

# Starts from generator?
func findAndUpdateConnectedComponents(startPoint: Vector2i, genID: int) -> void: #TODO: add gear ratios/different gear sizes
	var componentStack: Array[Vector2i] = [startPoint]
	var index: int = 0
	print("SEARCHING", startPoint)
	
	while componentStack.size() > index:
		# Special case for gear directly under gen
		if components.has(componentStack[index]) and componentStack[index] not in componentStack and componentStack[index] == startPoint:
			componentStack.insert(index + 1, componentStack[index])
			updateComponent(componentStack[index], genInfo[genID], startPoint)
		
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
	@warning_ignore("integer_division")
	var playerTilemapCoords: Vector2i = componentMap.local_to_map(player.position)

	if event.is_action_pressed("placeGear"): ##testing version of placing gear
		placeGear(playerTilemapCoords)

	if event.is_action_pressed("placeTestGen"):##testing version of placing generator
		placeTestGen(playerTilemapCoords)
		
	if event.is_action_pressed("Debug Tile Data"):
		printTileData(playerTilemapCoords)
		
	if event.is_action_pressed("place_fast_test_gen"):
		placeFastTestGen(playerTilemapCoords)

func updateGearRendering() -> void:
	for componentCoords in components:
		var component: Component = components[componentCoords]
		
		if component.genID == 0:
			if component.visualSpeed == 0:
				componentMap.set_cell(componentCoords, 0, Vector2i(0, 9))
			elif (componentCoords.x + componentCoords.y) % 2 == 0:
				@warning_ignore("integer_division")
				componentMap.set_cell(componentCoords, 0, Vector2i(21, int(3 * log(component.visualSpeed / 5) / log(2))))
			else:
				@warning_ignore("integer_division")
				componentMap.set_cell(componentCoords, 0, Vector2i(0, int(3 * log(component.visualSpeed / 5) / log(2))))
		else:
			groundMap.set_cell(componentCoords, 0, Vector2i(7, 0))

func updateGearLogic() -> void:
	for gearPos in gears:
		if gearPos not in components:
			push_warning("Cannot find gear pos in components", gearPos, ", removing")
			gears.erase(gearPos) # technical debt
			continue
		components[gearPos].firstCheck = true
		components[gearPos].resetTo()
	for genPos in generators:
		findAndUpdateConnectedComponents(genPos, components[genPos].genID)
	updateGearRendering()

func moveComponent(startPos: Vector2i, endPos: Vector2i) -> void:
	if components.has(endPos):
		print("something already at endpos")
	elif components.has(startPos):
		if components[startPos].genID == 0:
			gears.erase(startPos)
			gears.append(endPos)
			components[endPos] = components[startPos]
			components.erase(startPos)
		else:
			generators.erase(startPos)
			generators.append(endPos)
			components[endPos] = components[startPos]
			components.erase(startPos)
	else:
		print("nothing at startpos")
	updateGearLogic()
	updateGearRendering()

func placeComponent(component: Component, location: Vector2i) -> void:
	components[location] = component
	if component.genID == 0:
		gears.append(location)
	else:
		generators.append(location)
	
	updateGearLogic()
	updateGearRendering()

func placeGear(playerTilemapCoords: Vector2i) -> void:
	if playerTilemapCoords in generators:
		#generators.erase(playerTilemapCoords)
		gears.append(playerTilemapCoords)
		components[playerTilemapCoords].resetTo()
	elif playerTilemapCoords in components and playerTilemapCoords not in gears:
		gears.append(playerTilemapCoords)
		components[playerTilemapCoords].resetTo()
	else:
		gears.append(playerTilemapCoords)
		components[playerTilemapCoords] = Component.new()
		
	updateGearLogic()
	updateGearRendering()

func placeTestGen(playerTilemapCoords: Vector2i) -> void:
	if playerTilemapCoords in gears:
		#gears.erase(playerTilemapCoords)
		pass
	elif playerTilemapCoords in components:
		#generators.erase(playerTilemapCoords)
		pass
	else:
		pass
	generators.append(playerTilemapCoords)
	components[playerTilemapCoords] = Component.new(32, 0, 0, 1)
	
	updateGearLogic()
	updateGearRendering()

func placeFastTestGen(playerTilemapCoords: Vector2i) -> void:
	generators.append(playerTilemapCoords)
	components[playerTilemapCoords] = Component.new(32, 0, 0, 2)
	updateGearLogic()
	updateGearRendering()


## @deprecated: Testing purposes only
func popComponent(position: Vector2i) -> Component:
	var temp: Component = components[position]
	components.erase(position)
	return temp

func clearComponent(playerTilemapCoords: Vector2i) -> void:
	if playerTilemapCoords in gears:
		gears.erase(playerTilemapCoords)
	elif playerTilemapCoords in generators:
		generators.erase(playerTilemapCoords)
	if playerTilemapCoords in components:
		components.erase(playerTilemapCoords)
	
	updateGearLogic()
	updateGearRendering()

func printTileData(playerPos: Vector2i) -> void: ##press B to print tile data
	print("components: ", components)
	if components.has(playerPos):
		print("Component: " + str(components[playerPos].genID))
		print("Speed: " + str(components[playerPos].speed) + " Visual Speed: " + str(components[playerPos].visualSpeed) + " Torque: " + str(components[playerPos].torque))
