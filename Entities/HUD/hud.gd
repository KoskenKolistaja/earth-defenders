extends Control


@export var weapon_selection : PackedScene


var time = 2025




func _physics_process(delta):
	
	for id in PlayerData.players:
		var temporary = id + 1
		if Input.is_action_just_pressed("p%s_ready" % temporary):
			trigger_weapon_selection()
		


func trigger_weapon_selection():
	if not get_node_or_null("WeaponSelection"):
		var selection_instance = weapon_selection.instantiate()
		add_child(selection_instance)
		pause_space()



func pause_space():
	get_parent().pause_space()


func unpause_space():
	get_parent().unpause_space()





func update_time():
	time += 1
	$Time.text = str(time)


func _on_timer_timeout():
	update_time()
