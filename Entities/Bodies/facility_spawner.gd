extends Node3D















func get_free_position():
	var free_position = null
	for item in get_children():
		if item.get_children().size() < 1:
			free_position = item
	
	return free_position
