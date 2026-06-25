extends CharacterBody2D

@export var current_tm: TileMapLayer
@export var ground_tm: TileMapLayer
@export var underground_tm: TileMapLayer

@onready var terrain_tm: TileMapLayer = %Terrain


@export var debris: Node2D

@export var carrying := false

@onready var camera = %Camera2D
@onready var gearManager = %GearManager

var carrying_data

const TILE_SIZE = 32
const SPEED = 320.0
const LERP_SPEED = 0.08
const THROW_RANGE = 128

@onready var current_zoom = camera.zoom.x
const MAX_ZOOM := 4.0
const MIN_ZOOM := 1.0

const CARDINAL_2i_DIRS = [Vector2i(0, 1), Vector2i(1, 0), Vector2i(0, -1), Vector2i(-1, 0)]
const GEAR_COORDS = [Vector2i(0, 0), Vector2i(0, 3), Vector2i(0, 6), Vector2i(0, 9), Vector2i(21, 0), Vector2i(21, 3), Vector2i(21, 6)]
const GEN_COORDS = []
var animating_tile_pos = {}

@onready var mobdebug = preload("res://assets/mobs/enemy_basic.tscn")

# Gets the mouse pos in constraint to throw range
func get_local_constr_mouse_pos() -> Vector2:
	var mp = get_local_mouse_position()
	if mp.length() > THROW_RANGE:
		mp = mp.normalized() * THROW_RANGE
	return mp

func search_scene_at_tile_pos(tm: TileMapLayer, pos: Vector2i) -> Node2D:
	for node : Node2D in tm.get_children():
		if node.position == tm.map_to_local(pos):
			return node
	return null

# Get the texture of the current cell position
func cell_pos_to_texture(tm: TileMapLayer, tm_pos: Vector2i) -> Texture:
	var sid := tm.get_cell_source_id(tm_pos)
	var source = tm.tile_set.get_source(sid)
	var atl_coord: Vector2i
	var src : TileSetAtlasSource = tm.tile_set.get_source(0)

	if source is TileSetScenesCollectionSource:
		var altid = tm.get_cell_alternative_tile(tm_pos)
		var scene = source.get_scene_tile_scene(altid).instantiate()
		atl_coord = scene.atlas_texture
		scene.queue_free()
	else:
		atl_coord = tm.get_cell_atlas_coords(tm_pos)
	var rect := src.get_tile_texture_region(atl_coord)
	var img : Image = src.texture.get_image()
	var t_img := img.get_region(rect)
	return ImageTexture.create_from_image(t_img)


# Attempt to carry the tile at pos
func carry_at_pos(tm: TileMapLayer, pos: Vector2i):
	if current_tm.get_cell_source_id(pos) != -1:
		var altcoords = current_tm.get_cell_atlas_coords(pos)
		if altcoords == Vector2i(1, 3):
			GameStats.stone += 1
		elif altcoords == Vector2i(1, 4):
			GameStats.wood += 1
		elif altcoords == Vector2i(1,6):
			GameStats.iron += 1
		elif altcoords == Vector2i(1,7):
			GameStats.gold += 1
		else:
			carrying = true
			carrying_data = {
				atcoords = current_tm.get_cell_atlas_coords(pos),
				sid = current_tm.get_cell_source_id(pos),
				altid = current_tm.get_cell_alternative_tile(pos)
			}
			var img = cell_pos_to_texture(tm, pos)
			$Holding.texture = img
			$Aim.texture = img
			if current_tm.get_cell_atlas_coords(pos) in GEAR_COORDS or current_tm.get_cell_atlas_coords(pos) in GEN_COORDS:
				print("GEAR")
				carrying_data.component = true
				gearManager.clearComonent(pos)
							
			var source = tm.tile_set.get_source(carrying_data.sid)
			if source is TileSetScenesCollectionSource:
				var node = search_scene_at_tile_pos(tm, pos)
				if node and node.get_script() and (node.get_script() == Building or node.get_script().get_base_script() == Building):
					print(node.health)
					carrying_data.health = node.health
		tm.set_cell(pos, -1)

# Assumes that all terrain will only have collidable objects
func valid_player_drop_pos(add_tm: TileMapLayer, pos: Vector2i) -> bool:
	return add_tm.get_cell_source_id(pos) == -1  and terrain_tm.get_cell_source_id(pos) == -1 
		
func use_tool(tool: String, pos: Vector2i):
	for dir in CARDINAL_2i_DIRS:
		var new_pos = pos + dir
		var altcoords = terrain_tm.get_cell_atlas_coords(new_pos)
		var recipe_dict: Dictionary
		if tool == "Axe":
			recipe_dict = GameRecipes.axe_recipes
		elif tool == "Pickaxe":
			recipe_dict = GameRecipes.pickaxe_recipes
		else:
			push_error("Unknown tool/recipe:", tool)
		if altcoords in recipe_dict:
			terrain_tm.set_cell(new_pos, -1)
			ground_tm.set_cell(new_pos, 0, recipe_dict[altcoords])
			


# Attempt to drop the tile at pos
func drop_at_pos(tm: TileMapLayer, pos: Vector2i):
	if valid_player_drop_pos(tm, pos) and not pos in animating_tile_pos:
		carrying = false
		animating_tile_pos[pos] = true
		var saved_carrying_data = carrying_data
		var throw_obj = $Holding.duplicate()
		debris.add_child(throw_obj)
		throw_obj.position = position
		$Holding.texture = null
		$Aim.texture = null
		
		# Throw animation
		var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(throw_obj, "position", current_tm.map_to_local(pos), 0.6)
		var tween2 = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
		tween2.tween_property(throw_obj, "scale", Vector2(1.2, 1.2), 0.3)
		tween2.chain().tween_property(throw_obj, "scale", Vector2(1.0, 1.0), 0.3)
		tween2.play()
		tween.play()
		await tween.finished
		throw_obj.queue_free()
		if "component" in saved_carrying_data:
			gearManager.placeGear(pos)
			print(gearManager.components)
		
		tm.set_cell(pos, saved_carrying_data.sid, saved_carrying_data.atcoords, saved_carrying_data.altid)
			
		var source = tm.tile_set.get_source(saved_carrying_data.sid)
		if source is TileSetScenesCollectionSource:
			var scene = source.get_scene_tile_scene(saved_carrying_data.altid).instantiate()
			if scene.get_script() == Tool:
				use_tool(scene.tool_type, pos)
				scene.queue_free()
					
		animating_tile_pos.erase(pos)
		
		# For some reason godot has a small delay when placing scene tiles...
		if "health" in saved_carrying_data:
			await get_tree().create_timer(0.0025).timeout
			var sc = search_scene_at_tile_pos(tm, pos)
			if sc:
				sc.health = saved_carrying_data.health
			
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if not carrying:
			var tm_pos = ground_tm.local_to_map(position)
			carry_at_pos(current_tm, tm_pos)
		else:
			var thrw_pos = ground_tm.local_to_map(position + get_local_constr_mouse_pos())
			drop_at_pos(current_tm, thrw_pos)
	elif event.is_action_pressed("drop"):
		if carrying:
			var tm_pos = ground_tm.local_to_map(position)
			drop_at_pos(current_tm, tm_pos)
	elif event.is_action_pressed("switch_layer") and not carrying:
		if current_tm == ground_tm:
			current_tm = underground_tm
			var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT).set_parallel(true)
			tween.tween_property(ground_tm, "modulate", Color(1.0, 1.0, 1.0, 0.2), 0.2)
			tween.tween_property(underground_tm, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.2)
			tween.play()
		else:
			current_tm = ground_tm
			var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT).set_parallel(true)
			tween.tween_property(ground_tm, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.2)
			tween.tween_property(underground_tm, "modulate", Color(1.0, 1.0, 1.0, 0.2), 0.2)
			tween.play()
	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			if current_zoom < MAX_ZOOM:
				current_zoom += 0.1
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			if current_zoom > MIN_ZOOM:
				current_zoom -= 0.1
	elif event.is_action_pressed("spawnMobDebug"):
		var mob = mobdebug.instantiate()
		mob.position = position + Vector2(0, -32)
		%Mobs.add_child(mob)
		
			
func _process(delta: float) -> void:
	$Aim.position = get_local_constr_mouse_pos()
	camera.zoom = lerp(camera.zoom, Vector2.ONE * current_zoom, 0.1)

func _physics_process(delta: float) -> void:
	# Allow for buffer input of throwing
	if Input.is_action_pressed("interact") and not carrying:
		var tm_pos = ground_tm.local_to_map(position)
		carry_at_pos(current_tm, tm_pos)
		
	
	var direction := Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down")).normalized()
	velocity = lerp(velocity, direction * SPEED, LERP_SPEED)

	move_and_slide()
