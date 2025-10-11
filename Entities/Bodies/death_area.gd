extends Area3D


var active = false





func _physics_process(delta):
	if active:
		kill()
		$CollisionShape3D.shape.radius += 0.15




func kill():
	var areas = get_overlapping_areas()
	var bodies = get_overlapping_bodies()
	
	
	for item in areas:
		if item.has_method("die"):
			item.die()
	for item in bodies:
		if item.has_method("die"):
			item.die()
