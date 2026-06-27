extends CharacterBody2D

@export var SPEED = 95.0
@export var target: Node2D

signal health_changed()

@export var gold_dropped: int
@export var health: int = 100:
	set(value):
		health = value
		health_changed.emit()
@export var damage = 10

var has_target = false
var bullet = preload("res://assets/nodes/bullet.tscn")
@onready var shoot_tick: Timer = $ShootTick
var target_angle: float = 0

func fire():
	if not has_target: return
	var bul = bullet.instantiate()
	
	get_tree().get_first_node_in_group("Debris").add_child(bul)
	bul.position = position

	var tween = get_tree().create_tween()
	tween.tween_property(bul, "position", position + Vector2.UP.rotated(rotation) * 2000, 3.2)
	bul.body_entered.connect(func(body: Node2D):
		if body.is_in_group("buildings") and bul:
			if tween.is_running(): # deleting a node with a tween is playing throws a vague error
				tween.stop()
			body.health -= damage
			bul.queue_free()
	)
	tween.play()
	tween.finished.connect(func():
		if bul:
			bul.queue_free()
	)

func aimTick():
	var colls = $Range.get_overlapping_bodies()
	var closest: StaticBody2D
	var closest_dist: int = 999999999
	for col in colls:
		if col.is_in_group("buildings"):
			if (position - col.position).length() < closest_dist:
				closest_dist = (position - col.position).length()
				closest = col
	if closest:
		has_target = true
		var target_position = closest.position
		target_angle = target_position.angle_to_point(position) + deg_to_rad(-90)
	else:
		has_target = false

func ShootTick():

	if has_target:
		fire()

func _ready() -> void:
	$AimTick.timeout.connect(aimTick)
	$ShootTick.timeout.connect(ShootTick)
	health_changed.connect(func():
		if health <= 0:
			GameStats.gold += gold_dropped
			GameStats.current_mobs_defeated += 1
			queue_free()
		)
	if not target:
		target = get_tree().get_first_node_in_group("Target")

func _physics_process(delta: float) -> void:
	rotation = lerp_angle(rotation, target_angle, 0.1)
	if target:
		velocity = position.direction_to(target.position) * SPEED
	move_and_slide()
