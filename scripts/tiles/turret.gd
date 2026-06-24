extends Building

@export var speed: float = 1.0
@export var dmg: int = 25
@export var bullet_speed = 100


var target_angle: float = 0
var bullet = preload("res://assets/nodes/bullet.tscn")

func fire():
	var bul = bullet.instantiate()
	get_tree().get_first_node_in_group("Debris").add_child(bul)
	bul.position = position
	bul.body_entered.connect(func(body: Node2D):
		if body.is_in_group("Enemy"):
			body.health -= dmg
		bul.queue_free()
	)
	var tween = get_tree().create_tween()
	tween.tween_property(bul, "position", position + Vector2.RIGHT.rotated($Top.rotation + deg_to_rad(-90)) * 2000, 2.4)
	tween.play()
	tween.finished.connect(func():
		if bul:
			bul.queue_free()
	)
	
	
func tick():
	var colls = $Range.get_overlapping_bodies()
	var closest: CharacterBody2D
	var closest_dist: int = 999999999
	for col in colls:
		if col.is_in_group("Enemy"):
			if (position - col.position).length() < closest_dist:
				closest_dist = (position - col.position).length()
				closest = col
	if closest:
		var target_position = closest.position + (closest.velocity / 3)
		target_angle = position.angle_to_point(target_position) + deg_to_rad(90)
		
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Tick.timeout.connect(tick)
	$ShootTick.wait_time = speed
	$ShootTick.timeout.connect(fire)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Top.rotation = lerp_angle($Top.rotation, target_angle, 0.1)
