extends Control



@export var upgrade_panel : PackedScene






func spawn_upgrade_panel(player_id : int,weapon_ref,is_left):
	var panel_instance = upgrade_panel.instantiate()
	
	panel_instance.left = is_left
	panel_instance.player_id = player_id
	panel_instance.weapon_ref = weapon_ref
	
	get_parent().add_child(panel_instance)
