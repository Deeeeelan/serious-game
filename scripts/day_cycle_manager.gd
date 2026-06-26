extends Node

@onready var terrain_tm = %Terrain
@onready var center_label = %CenterLabel
@onready var mobs_node = %Mobs
@onready var mob_spawns = %MobSpawns

@export var time: int = 0
@export var current_mobs: int = 0

@export var day: int = 0
@export var is_night: bool = false

@export var first_day_time: int = 120
@export var day_time: int = 60

var max_mobs : int = 0

const SAFE_ZONES : Array[Rect2i] = [
	Rect2i(-10, -12, 20, 12)
]

const GENERATIONS = [
	{
		tile = Vector2i(3, 2),
		max = 40,
		bounds = [-50, 50, 0, -50]
	},
	{
		tile = Vector2i(2, 2),
		max = 60,
		bounds = [-60, 60, 0, -100]
	},
]
func first_night():
	var tween = get_tree().create_tween()
	%BGM.volume_db = -80.0
	%BGM.play()
	tween.tween_property(%BGM, "volume_db", 0.0, 14.0)
	tween.play()
	
func new_morning():
	is_night = false
	current_mobs = 0
	$Timer.start()
	time = 0
	day += 1
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

func new_night():
	is_night = true
	$Timer.stop()
	time = 0
	current_mobs = 0
	if day == 1:
		first_night()
	if day <= 14:
		if day not in MobWaves.waves:
			push_warning("Ran out of waves, pausing, day:", str(day))
			return
		var day_data = MobWaves.waves[day]
		max_mobs = day_data.total
		for mob in day_data.mobs:
			for i in range(mob.count): # i cant spell instantiate
				var mob_ent : CharacterBody2D = load(mob.path).instantiate()
				mob_ent.position = mob_spawns.get_children()[randi_range(0, mob_spawns.get_child_count() - 1)].position
				mobs_node.add_child(mob_ent)
				await get_tree().create_timer(mob.delay).timeout
				
	
func start_cycle():
	new_morning()
		

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GameStats.DEBUG:
		day_time = 5
		first_day_time = 8
	start_cycle()
	$Timer.timeout.connect(func():
		time += 1
		center_label.text = str((first_day_time if day == 1 else day_time) - time)
		if (day == 1 and time > first_day_time) or (day != 1 and time > day_time):
			new_night()
		)
	mobs_node.child_exiting_tree.connect(func(node: Node):
		current_mobs += 1
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_night:
		center_label.text = str(mobs_node.get_child_count()) + " Mob" + ("" if mobs_node.get_child_count() == 1 else "s")+" Left"
		if current_mobs >= max_mobs:
			current_mobs = 0
			new_morning()
