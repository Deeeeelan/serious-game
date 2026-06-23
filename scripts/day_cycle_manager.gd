extends Node

@onready var terrain_tm = %Terrain

const SAFE_ZONES : Array[Rect2i] = [
	Rect2i(-10, -12, 20, 12)
]

const GENERATIONS = [
	{
		tile = Vector2i(3, 2),
		max = 100,
		bounds = [-50, 50, 0, -50]
	},
	{
		tile = Vector2i(2, 2),
		max = 120,
		bounds = [-60, 60, 0, -100]
	},
]

func new_morning():
	for gen in GENERATIONS:
		for i in range(gen.max):
			var pos = Vector2i(randi_range(gen.bounds[0], gen.bounds[1]), randi_range(gen.bounds[2], gen.bounds[3]))
			var valid = true
			if terrain_tm.get_cell_source_id(pos) != -1:
				valid = false
			for safe in SAFE_ZONES:
				if safe.has_point(pos):
					valid = false
					break
			if valid:
				terrain_tm.set_cell(pos, 0, gen.tile)
		

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_morning()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
