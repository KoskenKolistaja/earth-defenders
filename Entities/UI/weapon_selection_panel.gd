extends Control

var player_id = 1

var selected_item = 0

var l = null
var r = null

var assigned_weapon_l = null
var assigned_weapon_r = null

var supervisor

var ready_to_continue = false


func _ready():
	update_cursor_position()
	$Cursor.show()


func _physics_process(delta):
	if Input.is_action_just_pressed("p%s_ui_left" % player_id):
		selected_item -= 1
		if selected_item < 0:
			selected_item = $HBoxContainer.get_children().size() - 1
		update_cursor_position()
	if Input.is_action_just_pressed("p%s_ui_right" % player_id):
		selected_item += 1
		if selected_item > $HBoxContainer.get_children().size() -1:
			selected_item = 0
		update_cursor_position()
	
	if Input.is_action_just_pressed("p%s_shoot1" % player_id) and not l == selected_item:
		assign_right_weapon()
	if Input.is_action_just_pressed("p%s_shoot2" % player_id) and not r == selected_item:
		assign_left_weapon()
	
	
	if Input.is_action_just_pressed("p%s_ready" % player_id):
		assign_selections()
		supervisor.player_ready(player_id)
		queue_free()

func assign_selections():
	var players = get_tree().get_nodes_in_group("player")
	
	print(players)
	
	if not players:
		return
	
	var player_in_question = null
	for player in players:
		if player.player_id == player_id:
			player_in_question = player
	
	print(player_in_question)
	if not player_in_question:
		return
	
	
	if assigned_weapon_r:
		player_in_question.stored_weapon_left = assigned_weapon_r
	if assigned_weapon_l:
		player_in_question.stored_weapon_right = assigned_weapon_l
	
	player_in_question.initiate_weapons()


func assign_right_weapon():
	assigned_weapon_r = $HBoxContainer.get_child(selected_item).name
	print(assigned_weapon_r)
	$RIGHT.global_position = $HBoxContainer.get_child(selected_item).global_position
	$RIGHT.show()
	r = selected_item

func assign_left_weapon():
	assigned_weapon_l = $HBoxContainer.get_child(selected_item).name
	print(assigned_weapon_l)
	$LEFT.global_position = $HBoxContainer.get_child(selected_item).global_position
	$LEFT.show()
	l = selected_item


func update_cursor_position():
	$Cursor.global_position = $HBoxContainer.get_child(selected_item).global_position
