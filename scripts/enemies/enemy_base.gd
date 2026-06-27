extends CharacterBody2D

@export var speed = 100.0
@export var target: Node2D
@export var damage = 10
@export var gold_dropped: int
@export var health: int = 100:
	set(value):
		health = value
		health_changed.emit()

var target_angle: float = 0
var is_boss: bool = false

signal health_changed()


func tick():
	var bodies = $Area2D.get_overlapping_bodies()
	for body : Node2D in bodies:
		var script: Script = body.get_script()
		if script and (script == Building or script.get_base_script() == Building):
			body.health -= damage

func aimTick():
	if abs(position.x) >= 6000 or abs(position.y) >= 6000:
		queue_free()
	var colls = $Range.get_overlapping_bodies()
	var closest: StaticBody2D
	var closest_dist: int = 999999999
	for col in colls:
		if col.is_in_group("buildings"):
			if (position - col.position).length() < closest_dist:
				closest_dist = (position - col.position).length()
				closest = col
	if closest:
		var target_position = closest.position
		target_angle = target_position.angle_to_point(position) + deg_to_rad(-90)
	else:
		target_angle = velocity.angle() + deg_to_rad(-90)
		
func _ready() -> void:

	$AimTick.timeout.connect(aimTick)
	$DamageTick.timeout.connect(tick)
	health_changed.connect(func():
		if health <= 0:
			GameStats.gold += gold_dropped
			GameStats.current_mobs_defeated += 1
			queue_free()
		)
	
	if not target:
		target = get_tree().get_first_node_in_group("Target")
	
	if is_boss:
		health *= 8
		damage *= 2
		speed *= 0.8
		modulate = Color(0.463, 0.388, 0.471, 1.0)
		
func _physics_process(delta: float) -> void:
	rotation = lerp_angle(rotation, target_angle, 0.1)

	if target:
		velocity = position.direction_to(target.position) * speed
	move_and_slide()
