extends CharacterBody2D

@export var ground_tm: TileMapLayer
@export var underground_tm: TileMapLayer

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

func _input(event: InputEvent) -> void:
	if event.is_action("interact"):
		var tm_pos = ground_tm.local_to_map(position)
		if ground_tm.get_cell_source_id(tm_pos) != -1:
			$Holding.texture = cell_pos_to_texture(ground_tm, tm_pos)

func _physics_process(delta: float) -> void:

	var direction := Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down")).normalized()
	velocity = lerp(velocity, direction * SPEED, LERP_SPEED)

	move_and_slide()
