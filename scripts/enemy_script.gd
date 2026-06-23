# Credit to https://casraf.dev/2024/09/pathfinding-guide-for-2d-top-view-tiles-in-godot-4-3/
# because I have no idea have to do this

# i didn't use this womp womp

extends CharacterBody2D
class_name Enemy

var speed := 50.0 # can be anything

@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var target: Node2D = %Target 

func _ready() -> void:
	actor_setup.call_deferred()
	nav.velocity_computed.connect(_velocity_computed)

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target(target.position)

func set_movement_target(movement_target: Vector2):
	nav.target_position = movement_target

func _physics_process(delta: float) -> void:
	_move_towards_player()

func _move_towards_player() -> void:
	# Update the player position
	set_movement_target(target.position)

	# If we're at the target, stop
	if nav.is_navigation_finished():
		return

	# Get pathfinding information
	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = nav.get_next_path_position()

	# Calculate the new velocity
	var new_velocity = current_agent_position.direction_to(next_path_position) * speed

	# Set correct velocity
	if nav.avoidance_enabled:
		nav.set_velocity(new_velocity)
	else:
		_velocity_computed(new_velocity)

	# Do the movement
	move_and_slide()

func _velocity_computed(safe_velocity: Vector2):
	velocity = safe_velocity
