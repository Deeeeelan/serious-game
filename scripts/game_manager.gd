extends Node

@export var base_health_copy: int = 9999
@export var game_end: bool = false

func lose():
	game_end = true
	base_health_copy = 0
	print("lose")
	
	%LoseText.visible_ratio = 0.0
	%Dark.color = Color(1.0, 1.0, 1.0, 0.0)
	%SFX2.volume_db = -80.0
	%AMB.play()
	%SFX2.play()
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(%AMB, "volume_db", -80.0, 5.0)
	tween.tween_property(%BGM, "volume_db", -80.0, 5.0)
	tween.tween_property(%SFX2, "volume_db", 0.0, 5.0)
	tween.tween_property(%Dark, "color", Color(1.0, 1.0, 1.0, 1.0), 5.0)
	tween.play()
	await tween.finished
	
	await get_tree().create_timer(4.0).timeout
	var tween2 = get_tree().create_tween().set_parallel(true)
	tween2.tween_property(%SFX2, "volume_db", -80.0, 4.0)
	tween2.play()
	await tween2.finished
	
	var tween3 = get_tree().create_tween().set_parallel(true)
	tween3.tween_property(%LoseText, "visible_ratio", 1.0, 1.0)
	tween3.play()
	await tween3.finished
	
	Engine.time_scale = 0.0 # just hope that nothing breaks
	
func win():
	game_end = true
	print("win")

func _process(delta: float) -> void:
	if base_health_copy <= 0 and not game_end:
		lose()
func _ready() -> void:
	%GearManager.placeTestGen(Vector2i(5, -7), 1)
