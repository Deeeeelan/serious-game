extends SpecialTile
class_name Building

@export var max_health : int
@export var do_not_die : bool = false


@export var health : int:
	set(value):
		health = value
		if value <= 0 and not do_not_die:
			get_tree().get_first_node_in_group("ground_tm").set_cell(get_tree().get_first_node_in_group("ground_tm").local_to_map(position), -1)
			queue_free()
			

func _ready() -> void:
	add_to_group("buildings")
