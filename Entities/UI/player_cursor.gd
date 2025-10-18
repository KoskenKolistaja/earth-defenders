extends TextureRect

var player_id = null
var selected_item = 0
 
var max_items = 0



func _ready():
	global_position = get_parent().get_cursor_position(selected_item)
	$Label.position.x = (player_id - 1) * 26
	$Label.text = str(player_id)
	max_items = get_parent().get_max_items()
	
	modulate = PlayerData.player_colors[player_id]
	
	await get_tree().physics_frame
	update_cursor_position()

func _process(delta):
	if Input.is_action_just_pressed("p%s_ui_left" % player_id):
		selected_item -= 1
		if selected_item < 0:
			selected_item = max_items - 1
		update_cursor_position()
		$Move.play()
	if Input.is_action_just_pressed("p%s_ui_right" % player_id):
		selected_item += 1
		if selected_item > max_items - 1:
			selected_item = 0
		update_cursor_position()
		$Move.play()
	
	
	if Input.is_action_just_pressed("p%s_ui_accept" % player_id):
		get_parent().assign_vote(player_id,selected_item)
		$Accept.play()


func update_cursor_position():
	global_position = get_parent().get_cursor_position(selected_item)
	global_position.x -= size.x / 2
	global_position.y -= size.y / 2
	if player_id == 1:
		get_parent().change_info(selected_item)
