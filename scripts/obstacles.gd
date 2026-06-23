extends TileMapLayer

var _obstacles: Array[TileMapLayer] = []

func _ready() -> void:
	_get_obstacle_layers()

func _get_obstacle_layers():
	# make sure the name here is the same as the group's
	var layers = get_tree().get_nodes_in_group("Obstacles")

	for layer in layers:
		if layer is not TileMapLayer: continue
		_obstacles.append(layer)

func _use_tile_data_runtime_update(coords: Vector2i) -> bool:
	return _is_used_by_obstacle(coords)

func _is_used_by_obstacle(coords: Vector2i) -> bool:
	for layer in _obstacles:
		if coords in layer.get_used_cells():
			var is_obstacle = layer.get_cell_tile_data(coords).get_collision_polygons_count(0) > 0 or layer.get_cell_tile_data(coords).get_collision_polygons_count(1) > 0
			if is_obstacle:
				return true
	return false
	
func _tile_data_runtime_update(coords: Vector2i, tile_data: TileData) -> void:
	if _is_used_by_obstacle(coords): # supposed to be not?
		print(coords)
		tile_data.set_navigation_polygon(0, null)
	else:
		var new_navigation_mesh = NavigationPolygon.new()
		var bounding_outline = PackedVector2Array([Vector2(0, 0), Vector2(0, 50), Vector2(50, 50), Vector2(50, 0)])
		new_navigation_mesh.add_outline(bounding_outline)
		NavigationServer2D.bake_from_source_geometry_data(new_navigation_mesh, NavigationMeshSourceGeometryData2D.new());
		tile_data.set_navigation_polygon(0, new_navigation_mesh)
