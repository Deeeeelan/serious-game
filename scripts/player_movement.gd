extends CharacterBody2D

@export var current_tm: TileMapLayer
@export var ground_tm: TileMapLayer
@export var underground_tm: TileMapLayer

@onready var terrain_tm: TileMapLayer = %Terrain


@export var debris: Node2D

@export var carrying := false
var carrying_data

const TILE_SIZE = 32
const SPEED = 320.0
const LERP_SPEED = 0.08
const THROW_RANGE = 128

var animating_tile_pos = {}

# Gets the mouse pos in constraint to throw range
func get_local_constr_mouse_pos() -> Vector2:
	var mp = get_local_mouse_position()
	if mp.length() > THROW_RANGE:
		mp = mp.normalized() * THROW_RANGE
	return mp

# Get the texture of the current cell position
func cell_pos_to_texture(tm: TileMapLayer, tm_pos: Vector2i) -> Texture:
	var sid := tm.get_cell_source_id(tm_pos)
	var source = tm.tile_set.get_source(sid)
	var atl_coord: Vector2i
	var src : TileSetAtlasSource = tm.tile_set.get_source(0)

	if source is TileSetScenesCollectionSource:
		atl_coord = source.get_scene_tile_scene(1).instantiate().atlas_texture
		print(atl_coord)

	else:
		atl_coord = tm.get_cell_atlas_coords(tm_pos)
	var rect := src.get_tile_texture_region(atl_coord)
	var img : Image = src.texture.get_image()
	var t_img := img.get_region(rect)
	return ImageTexture.create_from_image(t_img)

# Attempt to carry the tile at pos
func carry_at_pos(tm: TileMapLayer, pos: Vector2i):
	if current_tm.get_cell_source_id(pos) != -1:
		carrying = true
		carrying_data = {
			atcoords = current_tm.get_cell_atlas_coords(pos),
			sid = current_tm.get_cell_source_id(pos),
			altid = current_tm.get_cell_alternative_tile(pos)
		}
		var img = cell_pos_to_texture(tm, pos)
		$Holding.texture = img
		$Aim.texture = img
		tm.set_cell(pos, -1)

# Assumes that all terrain will only have collidable objects
func valid_player_drop_pos(add_tm: TileMapLayer, pos: Vector2i) -> bool:
	return add_tm.get_cell_source_id(pos) == -1  and terrain_tm.get_cell_source_id(pos) == -1 
		

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
		tm.set_cell(pos, saved_carrying_data.sid, saved_carrying_data.atcoords, saved_carrying_data.altid)
		animating_tile_pos.erase(pos)

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

func _process(delta: float) -> void:
	$Aim.position = get_local_constr_mouse_pos()

func _physics_process(delta: float) -> void:
	# Allow for buffer input of throwing
	if Input.is_action_pressed("interact") and not carrying:
		var tm_pos = ground_tm.local_to_map(position)
		carry_at_pos(current_tm, tm_pos)
		
	
	var direction := Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down")).normalized()
	velocity = lerp(velocity, direction * SPEED, LERP_SPEED)

	move_and_slide()
