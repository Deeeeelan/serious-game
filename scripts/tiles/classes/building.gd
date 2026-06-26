extends SpecialTile
class_name Building

@export var max_health : int
@export var do_not_die : bool = false


@export var health : int:
	set(value):
		health = value
		if value <= 0 and not do_not_die:
			print("building dead")
			queue_free()
