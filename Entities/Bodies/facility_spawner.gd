extends Node3D








func get_xp_multiplier():
	var multiplier = 1
	
	for item in get_children():
		if item.get_child(0).name == "technology_institute":
			multiplier += 1
	
	return multiplier






func get_free_position():
	var free_position = null
	for item in get_children():
		if item.get_children().size() < 1:
			free_position = item
	
	return free_position
