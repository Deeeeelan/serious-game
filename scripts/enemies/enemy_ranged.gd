extends CharacterBody2D

@export var SPEED = 75.0
@export var target: Node2D

signal health_changed(new)

@export var gold_dropped: int
@export var health: int = 100:
	set(value):
		health = value
		health_changed.emit(health)
@export var damage = 10


func tick():
	var bodies = $Area2D.get_overlapping_bodies()
	for body : Node2D in bodies:
		var script: Script = body.get_script()
		if script and (script == Building or script.get_base_script() == Building):
			body.health -= damage

func _ready() -> void:
	$DamageTick.timeout.connect(tick)
	health_changed.connect(func(new):
		if health <= 0:
			GameStats.gold += gold_dropped
			GameStats.current_mobs_defeated += 1
			queue_free()
		)
	if not target:
		target = get_tree().get_first_node_in_group("Target")


	

func _physics_process(delta: float) -> void:
	if target:
		velocity = position.direction_to(target.position) * SPEED
	move_and_slide()
