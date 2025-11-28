extends Area3D







func _on_timer_timeout():
	var earth = get_tree().get_first_node_in_group("earth")
	earth.add_shield(1)
