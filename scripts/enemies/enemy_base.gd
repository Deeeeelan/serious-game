extends CharacterBody2D

@export var SPEED = 100.0
@export var target: Node2D

@export var health = 100
@export var damage = 10

func tick():
	var bodies = $Area2D.get_overlapping_bodies()
	for body : Node2D in bodies:
		var script: Script = body.get_script()
		if script and (script == Building or script.get_base_script() == Building):
			body.health -= damage
func _ready() -> void:
	$DamageTick.timeout.connect(tick)

func _physics_process(delta: float) -> void:
	velocity = position.direction_to(target.position) * SPEED
	move_and_slide()
