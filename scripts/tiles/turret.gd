extends Building

@export var speed: float = 1.0
@export var bul_cd: float = 1.0
@export var dmg: int = 25
var real_dmg: int = dmg
@export var bullet_speed = 100



var target_angle: float = 0
var bullet = preload("res://assets/nodes/bullet.tscn")

var has_target := false

func fire():
	if not has_target: return
	var bul = bullet.instantiate()
	get_tree().get_first_node_in_group("Debris").add_child(bul)
	bul.position = position

	var tween = get_tree().create_tween()
	tween.tween_property(bul, "position", position + Vector2.RIGHT.rotated($Top.rotation + deg_to_rad(-90)) * 2000, 3.2)
	bul.body_entered.connect(func(body: Node2D):
		if body.is_in_group("Enemy") and bul:
			if tween.is_running(): # deleting a node with a tween is playing throws a vague error
				tween.stop()
			body.health -= real_dmg
			bul.queue_free()
	)
	tween.play()
	tween.finished.connect(func():
		if bul:
			bul.queue_free()
	)
	
	
func tick():
	var data = get_tree().get_first_node_in_group("gear_manager").request_gear_data_at(position)
	if data and data.speed > 0:
		if $ShootTick.is_stopped():
			$ShootTick.start()
		$ShootTick.wait_time = bul_cd / (data.speed / 5.0)
		real_dmg = int(dmg * (data.torque / 50.0))
		
	else:
		$ShootTick.stop()
	var colls = $Range.get_overlapping_bodies()
	var closest: CharacterBody2D
	var closest_dist: int = 999999999
	for col in colls:
		if col.is_in_group("Enemy"):
			if (position - col.position).length() < closest_dist:
				closest_dist = (position - col.position).length()
				closest = col
	if closest:
		has_target = true
		var target_position = closest.position + (closest.velocity / 3)
		target_angle = position.angle_to_point(target_position) + deg_to_rad(90)
	else:
		has_target = false
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Tick.timeout.connect(tick)
	$ShootTick.wait_time = bul_cd
	$ShootTick.wait_time = speed
	$ShootTick.timeout.connect(fire)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Top.rotation = lerp_angle($Top.rotation, target_angle, 0.1)
