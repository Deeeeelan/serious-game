extends ProgressBar

@onready var player = %Player
@onready var ground = %Ground


func tick():
	var tile : Node2D = player.search_scene_at_tile_pos(ground, ground.local_to_map(player.position))
	if tile and tile.get_script() and (tile.get_script() == Building or tile.get_script().get_base_script() == Building):
		visible = true
		value = float(tile.health) / float(tile.max_health)
	else:
		visible = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$SearchTick.timeout.connect(tick)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
