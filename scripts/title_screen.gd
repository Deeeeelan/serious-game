extends Node

@export var start_button: Button

const GAME_PATH = "res://scenes/game.tscn"

func start():
	get_tree().change_scene_to_file(GAME_PATH)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_button.pressed.connect(start)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
