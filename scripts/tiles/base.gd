extends Building

func _process(delta: float) -> void:
	get_tree().get_first_node_in_group("game_manager").base_health_copy = health
