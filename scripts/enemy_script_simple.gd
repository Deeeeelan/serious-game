extends CharacterBody2D

@export var SPEED = 100.0
@export var target: Node2D

@export var health = 100
@export var damage = 10

func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	velocity = position.direction_to(target.position) * SPEED
	move_and_slide()
