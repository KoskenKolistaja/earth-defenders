extends Node3D



func add_facility(exported_name):
	var facility_instance = ItemData.facilities[exported_name].instantiate()
	var free_position = get_free_position()
	if not free_position:
		return
	free_position.add_child(facility_instance)
	
	
	if exported_name == "technology_institute":
		set_xp_multiplier_for_weapons()



func set_xp_multiplier_for_weapons():
	var weapons = get_tree().get_nodes_in_group("weapon")
	
	for weapon in weapons:
		weapon.xp_multiplier = get_xp_multiplier()


func get_xp_multiplier():
	var multiplier = 1
	
	for item in get_children():
		if not item.get_child(0):
			continue
		
		if item.get_child(0).name == "technology_institute":
			multiplier += 1
	
	return multiplier


func get_free_position():
	var free_position = null
	for item in get_children():
		if item.get_children().size() < 1:
			free_position = item
	
	return free_position
