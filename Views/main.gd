extends Control




func _ready():
	
	var autolabel = get_tree().get_first_node_in_group("auto_label")
	autolabel.add_text("War declared by the Martians")
	autolabel.add_text("You have approximately 100 years to prepare")


func pause_space():
	get_tree().paused = true





#func pause_space():
	#$Space.process_mode = Node.PROCESS_MODE_DISABLED

func unpause_space():
	get_tree().paused = false
