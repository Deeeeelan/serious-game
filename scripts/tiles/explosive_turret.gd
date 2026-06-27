extends Turret

const EXPLOSION = preload("res://assets/nodes/explosion.tscn")

func explosion(location: Vector2):
	var explosionArea = EXPLOSION.instantiate()
	var explosionTimer = explosionArea.get_node("ParticleTimer")
	explosionTimer.timeout.connect(func(): explosionArea.queue_free())
	explosionArea.position = location
	get_tree().get_first_node_in_group("Debris").add_child(explosionArea)
	var explosionBodies = explosionArea.get_overlapping_bodies()
	
	for body in explosionBodies:
		if body.is_in_group("Enemy"):
			body.health -= real_dmg
	
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
			explosion(bul.location)
			bul.queue_free()
	)
	tween.play()
	tween.finished.connect(func():
		if bul:
			bul.queue_free()
	)
