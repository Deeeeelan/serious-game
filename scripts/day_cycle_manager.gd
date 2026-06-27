extends Node

@onready var terrain_tm = %Terrain
@onready var center_label = %CenterLabel
@onready var mobs_node = %Mobs
@onready var mob_spawns = %MobSpawns
@onready var ground_tm = %Ground
@onready var canvas_mod = %CanvasModulate

@export var time: int = 0
@export var current_mobs: int = 0

@export var day: int = 7
@export var is_night: bool = false

@export var first_day_time: int = 120
@export var day_time: int = 60
var endless_total:int = 0

var day_color = Color("#d4d4d4")
var night_color = Color("#636363")
var night2_color = Color("#3b2f2a")


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
	var tween = get_tree().create_tween()
	tween.tween_property(canvas_mod, "color", day_color, 4.0)
	tween.play()
	$Timer.start()
	time = 0
	day += 1
	if day == 8:
		%GameManager.win()
	for gen in GENERATIONS:
		for i in range(gen.max):
			var pos = Vector2i(randi_range(gen.bounds[0], gen.bounds[1]), randi_range(gen.bounds[2], gen.bounds[3]))
			var valid = true
			if terrain_tm.get_cell_source_id(pos) != -1 or ground_tm.get_cell_source_id(pos) != -1:
				valid = false
			for safe in SAFE_ZONES:
				if safe.has_point(pos):
					valid = false
					break
			if valid:
				terrain_tm.set_cell(pos, 0, gen.tile)

func spawn_mob(path: String, amt: int, delay: float, boss: bool):
	for i in range(amt): # i cant spell instantiate
		var mob_ent : CharacterBody2D = load(path).instantiate()
		if boss:
			mob_ent.is_boss = true
		mob_ent.position = mob_spawns.get_children()[randi_range(0, mob_spawns.get_child_count() - 1)].position
		mobs_node.add_child(mob_ent)
		await get_tree().create_timer(delay).timeout

func new_night():
	is_night = true
	$Timer.stop()
	time = 0
	current_mobs = 0
	var tween = get_tree().create_tween()
	tween.tween_property(canvas_mod, "color", night2_color if day % 7 == 0 else night_color, 4.0)
	tween.play()
	if day == 1:
		first_night()
	if day <= 7:
		if day not in MobWaves.waves:
			push_warning("Ran out of waves, pausing, day:", str(day))
			return
		var day_data = MobWaves.waves[day]
		max_mobs = day_data.total
		for mob in day_data.mobs:
			for i in range(mob.count): # i cant spell instantiate
				var mob_ent : CharacterBody2D = load(mob.path).instantiate()
				if mob.has("boss"):
					if mob["boss"] != 0:
						mob_ent.is_boss = true
						mob["boss"] -= 1
				mob_ent.position = mob_spawns.get_children()[randi_range(0, mob_spawns.get_child_count() - 1)].position
				mobs_node.add_child(mob_ent)
				await get_tree().create_timer(mob.delay).timeout
	else:
		endless_total = (day * 2) + (day * 2 - 4)
		if day % 3 == 0 or day >= 14:
			if day % 2 == 0 or day >= 14:
				endless_total += day / 7
			endless_total += day / 7
		if day >= 14:
			endless_total += day / 2
			endless_total += day / 2
		max_mobs = endless_total
		spawn_mob("res://assets/mobs/enemy_basic.tscn", day * 2, 0.4, false)
		spawn_mob("res://assets/mobs/enemy_ranged.tscn", day * 2 - 4, 0.5, false)
		if day % 3 == 0 or day >= 14:
			await get_tree().create_timer(5.0).timeout
			if day % 2 == 0 or day >= 14:
				spawn_mob("res://assets/mobs/enemy_ranged.tscn", day/7, 1, true)
			spawn_mob("res://assets/mobs/enemy_basic.tscn", day/7, 1, true)
		if day >= 14:
			spawn_mob("res://assets/mobs/enemy_basic.tscn", day / 2, 0.6, true)
			spawn_mob("res://assets/mobs/enemy_ranged.tscn", day / 2, 0.6, true)

	
func start_cycle():
	new_morning()
		

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GameStats.DEBUG:
		day_time = 5
		first_day_time = 8
	
	%AMB.volume_db = -80.0
	%Dark.color = Color(0.0, 0.0, 0.0, 1.0)
	%AMB.play()
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(%AMB, "volume_db", 0.0, 2.0)
	tween.tween_property(%Dark, "color", Color(0.0, 0.0, 0.0, 0.0), 2.0)
	tween.play()
	
	
	start_cycle()
	$Timer.timeout.connect(func():
		time += 1
		center_label.text = "Day " + str(day) + "\n" + str((first_day_time if day == 1 else day_time) - time)
		if (day == 1 and time > first_day_time) or (day != 1 and time > day_time):
			new_night()
		)
	mobs_node.child_exiting_tree.connect(func(node: Node):
		current_mobs += 1
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_night:
		center_label.text = "Day " + str(day) + "\n" + str(mobs_node.get_child_count()) + " Mob" + ("" if mobs_node.get_child_count() == 1 else "s")+" Left"
		if current_mobs >= max_mobs:
			current_mobs = 0
			new_morning()
