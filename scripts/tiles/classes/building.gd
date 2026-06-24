extends SpecialTile
class_name Building

@export var max_health : int

@export var health : int:
	set(value):
		health = value
		if value <= 0:
			print("building dead")
			queue_free()
