extends CharacterBody2D

@export var current_tm: TileMapLayer
@export var ground_tm: TileMapLayer
@export var underground_tm: TileMapLayer

@export var carrying := false
var carrying_data

const TILE_SIZE = 32
const SPEED = 320.0
const LERP_SPEED = 0.08

func cell_pos_to_texture(tm: TileMapLayer, tm_pos: Vector2i) -> Texture:
	var sid := tm.get_cell_source_id(tm_pos)
	var src : TileSetAtlasSource = tm.tile_set.get_source(sid) as TileSetAtlasSource
	var atl_coord := tm.get_cell_atlas_coords(tm_pos)
	var rect := src.get_tile_texture_region(atl_coord)
	var img : Image = src.texture.get_image()
	var t_img := img.get_region(rect)
	return ImageTexture.create_from_image(t_img)

func carry_at_pos(tm: TileMapLayer, pos: Vector2i):
	if current_tm.get_cell_source_id(pos) != -1:
		carrying = true
		carrying_data = current_tm.get_cell_atlas_coords(pos)
		var img = cell_pos_to_texture(tm, pos)
		$Holding.texture = img
		$Aim.texture = img
		tm.set_cell(pos, -1)

func drop_at_pos(tm: TileMapLayer, pos: Vector2i):
	if tm.get_cell_source_id(pos) == -1:
		carrying = false
		$Holding.texture = null
		$Aim.texture = null
		tm.set_cell(pos, 0, carrying_data)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if not carrying:
			var tm_pos = ground_tm.local_to_map(position)
			carry_at_pos(current_tm, tm_pos)
		else:
			var thrw_pos = ground_tm.local_to_map(position + get_local_mouse_position())
			drop_at_pos(current_tm, thrw_pos)
	elif event.is_action_pressed("drop"):
		if carrying:
			var tm_pos = ground_tm.local_to_map(position)
			drop_at_pos(current_tm, tm_pos)
	elif event.is_action_pressed("switch_layer") and not carrying:
		if current_tm == ground_tm:
			current_tm = underground_tm
			ground_tm.modulate = Color(1.0, 1.0, 1.0, 0.5)
			underground_tm.modulate = Color(1.0, 1.0, 1.0, 1.0)
		else:
			current_tm = ground_tm
			ground_tm.modulate = Color(1.0, 1.0, 1.0, 1.0)
			underground_tm.modulate = Color(1.0, 1.0, 1.0, 0.5)

func _process(delta: float) -> void:
	$Aim.position = get_local_mouse_position()

func _physics_process(delta: float) -> void:
	
	if Input.is_action_pressed("interact") and not carrying:
		var tm_pos = ground_tm.local_to_map(position)
		carry_at_pos(current_tm, tm_pos)
		
	
	var direction := Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down")).normalized()
	velocity = lerp(velocity, direction * SPEED, LERP_SPEED)

	move_and_slide()
