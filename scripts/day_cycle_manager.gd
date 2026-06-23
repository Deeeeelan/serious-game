extends Node

@onready var terrain_tm = %Terrain

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
			if terrain_tm.get_cell_source_id(pos) == -1:
				terrain_tm.set_cell(pos, 0, gen.tile)
		

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_morning()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
