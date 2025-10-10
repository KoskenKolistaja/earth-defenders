extends Node3D











func fracture(exported_velocity):
	
	top_level = false
	
	var fractures = get_children()
	
	
	for f in fractures:
		var multiplier = 3
		var additional_velocity = (f.get_collision_shape_position() - self.global_position) * multiplier
		var combined_velocity = (exported_velocity * 0.5) + additional_velocity
		var result_velocity = Vector3(combined_velocity.x,combined_velocity.y,0)
		
		f.velocity = result_velocity
		f.call_deferred("activate")
