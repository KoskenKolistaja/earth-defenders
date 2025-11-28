extends Control

var player_id = 1


var selected_item = 0

var spawned = false



func _ready():
	update_selection()
	update_cursor_position()
	$Panel/PlayerName.text = PlayerData.player_names[player_id]
	$Panel/Base/PlayerIcon.texture = PlayerData.player_icons[player_id]
	
	var player_color : Color = PlayerData.player_colors[player_id]
	
	player_color.a = 0.5
	$Panel.self_modulate = player_color


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

func _physics_process(_delta):
	if Input.is_action_just_pressed("p%s_ui_left" % player_id):
		selected_item -= 1
		if selected_item < 0:
			selected_item = $Panel/Selection.get_children().size() - 1
		update_cursor_position()
		if $Panel/Selection.visible:
			$Move.play()
	if Input.is_action_just_pressed("p%s_ui_right" % player_id):
		selected_item += 1
		if selected_item > $Panel/Selection.get_children().size() -1:
			selected_item = 0
		update_cursor_position()
		if $Panel/Selection.visible:
			$Move.play()
	
	if Input.is_action_just_pressed("p%s_ui_accept" % player_id):
		if $Panel/Selection.visible:
			$Accept.play()
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


func update_hp(hp,max_hp):
	var amount = snappedi(float(hp) / float(max_hp) * 100, 1)
	$Panel/Base/HPBar.value = amount
	$Panel/Base/HPBar/Label.text = str(hp) + "/" + str(max_hp)

func update_xp(xp,xp_needed,left : bool = false):
	
	var amount = snappedi(float(xp) / float(xp_needed) * 100, 1)
	
	if left:
		$Panel/Base/LeftWeaponXP.value = amount
		$Panel/Base/LeftWeaponXP.show()
		$Panel/Base/LeftWeaponXP/XPAmount.text = "xp: " + str(xp) + "/" + str(xp_needed)
	else:
		$Panel/Base/RightWeaponXP.value = amount
		$Panel/Base/RightWeaponXP.show()
		$Panel/Base/RightWeaponXP/XPAmount.text = "xp: " + str(xp) + "/" + str(xp_needed)

func update_weapon_name(exported_name,left):
	
	var formatted_name = format_name(exported_name)
	
	if left:
		$Panel/Base/LeftWeaponXP/WeaponName.text = formatted_name
	else:
		$Panel/Base/RightWeaponXP/WeaponName.text = formatted_name

func format_name(exported_name: String) -> String:
	var formatted = exported_name.replace("_", " ")
	formatted = formatted.capitalize() # Capitalizes first letter, but only of first word
	
	# Capitalize every word
	var words = formatted.split(" ")
	for i in range(words.size()):
		words[i] = words[i].capitalize()
	
	return " ".join(words)
