extends SpecialTile
class_name Building

signal health_changed(new)


@export var health : int = 100:
	set(value):
		health = value
		health_changed.emit(health)

func _ready() -> void:
	health_changed.connect(func(new):
		if health <= 0:
			print("building dead")
			queue_free()
		)
