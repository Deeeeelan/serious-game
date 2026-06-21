extends CharacterBody2D


const SPEED = 320.0
const LERP_SPEED = 0.08

func _physics_process(delta: float) -> void:

	var direction := Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down")).normalized()
	velocity = lerp(velocity, direction * SPEED, LERP_SPEED)

	move_and_slide()
