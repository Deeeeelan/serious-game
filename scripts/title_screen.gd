extends Node

@export var start_button: Button
var starting := false

const GAME_PATH = "res://scenes/game.tscn"

func start():
	if not starting:
		starting = true
		var tween = get_tree().create_tween().set_parallel(true)
		tween.tween_property(%AMB, "volume_db", -80.0, 3.0)
		tween.tween_property(%Dark, "color", Color(0.0, 0.0, 0.0, 1.0), 3.0)
		tween.play()
		await tween.finished
	
		get_tree().change_scene_to_file(GAME_PATH)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_button.pressed.connect(start)
	%AMB.volume_db = -80.0
	%AMB.play()
	var tween = get_tree().create_tween()
	tween.tween_property(%AMB, "volume_db", 0.0, 2.0)
	tween.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
