extends Area3D


func _on_timer_timeout():
	var hud = get_tree().get_first_node_in_group("hud")
	
	hud.add_money(100)
