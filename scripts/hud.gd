extends Control

func _process(delta: float) -> void:
	$VBoxContainer/RichTextLabel.text =\
"[b]Gold:[/b] %s
[b]Wood:[/b] %s
[b]Stone:[/b] %s
[b]Iron:[/b] %s" % [str(GameStats.gold), str(GameStats.wood), str(GameStats.stone), str(GameStats.iron)]

func _ready() -> void:
	$VBoxContainer/Crafting.pressed.connect(func():
		$"../Crafting".visible = not $"../Crafting".visible
	)
	
