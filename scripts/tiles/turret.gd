extends Building

@export var speed: float = 1
@export var dmg: int = 25

func tick():
	var coll = $Range.get_overlapping_bodies()
	print(coll)
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Tick.timeout.connect(tick)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
