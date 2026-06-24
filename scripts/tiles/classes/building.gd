extends SpecialTile
class_name Building

signal health_changed(new)

@export var max_health : int

@export var health : int:
	set(value):
		health = value
		health_changed.emit(health)

func _ready() -> void:
	health_changed.connect(func(new):
		if health <= 0:
			print("building dead")
			queue_free()
		)
