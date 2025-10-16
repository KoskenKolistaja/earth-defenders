extends Control

var player_id = 1


var selected_item = 0

var spawned = false



func _ready():
	update_selection()
	update_cursor_position()
	$Panel/PlayerName.text = "Player " + str(player_id)

func update_selection():
	var spaceport = get_tree().get_first_node_in_group("spaceport")
	
	if not spaceport:
		return
	
	var dictionary = spaceport.reserved_ships
	
	for key in dictionary:
		if dictionary[key] > 0:
			for item in $Panel/Selection.get_children():
				if item.name == key:
					item.get_child(0).text = str(dictionary[key])
		else:
			for item in $Panel/Selection.get_children():
				if item.name == key:
					item.get_child(0).text = str(dictionary[key])



func update_cursor_position():
	var texture_item = $Panel/Selection.get_child(selected_item)
	$Panel/Cursor.global_position = texture_item.global_position

func _physics_process(delta):
	if Input.is_action_just_pressed("p%s_ui_left" % player_id):
		selected_item -= 1
		if selected_item < 0:
			selected_item = $Panel/Selection.get_children().size() - 1
		update_cursor_position()
	if Input.is_action_just_pressed("p%s_ui_right" % player_id):
		selected_item += 1
		if selected_item > $Panel/Selection.get_children().size() -1:
			selected_item = 0
		update_cursor_position()
	
	if Input.is_action_just_pressed("p%s_ui_accept" % player_id):
		if not spawned:
			spawn_ship()




func spawn_ship():
	var spaceport = get_tree().get_first_node_in_group("spaceport")
	
	if not spaceport:
		return
	
	var ship_name =  $Panel/Selection.get_child(selected_item).name
	
	if spaceport.reserved_ships[ship_name] < 1:
		return
	
	$Panel/Cursor.hide()
	$Panel/Selection.hide()
	$Panel/Base.show()
	
	spaceport.spawn_ship(ship_name,player_id)
	
	get_tree().call_group("ship_hud" , "update_selection")
	
	spawned = true


func update_hp(exported_value):
	$Panel/Base/HPBar.value = exported_value
