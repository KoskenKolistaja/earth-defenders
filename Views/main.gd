extends Control




func _ready():
	
	var autolabel = get_tree().get_first_node_in_group("auto_label")
	autolabel.add_text("War declared by the Martians")
	autolabel.add_text("You have approximately 100 years to prepare")
	
	Statistics.initialize_from_playerdata()

func pause_space():
	get_tree().paused = true


func check_records():
	pass



#func pause_space():
	#$Space.process_mode = Node.PROCESS_MODE_DISABLED

func unpause_space():
	get_tree().paused = false


func _on_restart_pressed():
	MetaData.reset_settings()
	unpause_space()
	get_tree().reload_current_scene()


func _on_to_menu_pressed():
	unpause_space()
	get_tree().change_scene_to_file("res://Views/menu.tscn")
