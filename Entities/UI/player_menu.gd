extends Control


var player_id = 1

var prince_icon : Texture = preload("res://Assets/Textures/PlayerIcons/Prince.png")
var diplomat_icon : Texture = preload("res://Assets/Textures/PlayerIcons/Diplomat.png")
var pilot_icon : Texture = preload("res://Assets/Textures/PlayerIcons/Pilot.png")


var vertical_index = 0

var icon_index = 0
var name_index = 0
var color_index = 0


var names = ["Prince","Diplomat","Pilot"]
@onready var icons = [prince_icon,diplomat_icon,pilot_icon]
var colors = [Color(0.7,0.7,1),Color(0,0.7,0),Color(1,0,1),Color(0,1,1)]

var submitted = false



func _ready():
	icon_index = player_id - 1
	name_index = player_id - 1
	color_index = player_id - 1
	
	set_icon()
	set_player_name()
	set_color()
	
	
	move_cursor()




func _process(delta):
	
	if Input.is_action_just_pressed("p%s_ui_return" % player_id):
		if submitted:
			unsubmit()
		else:
			get_parent().erase_player(player_id)
			queue_free()
	
	if submitted:
		return
	
	if Input.is_action_just_pressed("p%s_ui_left" % player_id):
		$Move.play()
		match vertical_index:
			0:
				icon_index -= 1
				if icon_index < 0:
					icon_index = icons.size() -1
				do_action(icon_index)
			1:
				name_index -= 1
				if name_index < 0:
					name_index = names.size() -1
				do_action(name_index)
			2:
				color_index -= 1
				if color_index < 0:
					color_index = colors.size() -1
				do_action(color_index)
	if Input.is_action_just_pressed("p%s_ui_right" % player_id):
		$Move.play()
		match vertical_index:
			0:
				icon_index += 1
				if icon_index > icons.size() - 1:
					icon_index = 0
				do_action(icon_index)
			1:
				name_index += 1
				if name_index > names.size() - 1:
					name_index = 0
				do_action(name_index)
			2:
				color_index += 1
				if color_index > colors.size() - 1:
					color_index = 0
				do_action(color_index)
	
	
	if Input.is_action_just_pressed("p%s_ui_up" % player_id):
		vertical_index -= 1
		if vertical_index < 0:
			vertical_index = $VBoxContainer.get_child_count() - 1
		move_cursor()
		$Move2.play()
	if Input.is_action_just_pressed("p%s_ui_down" % player_id):
		vertical_index += 1
		if vertical_index > $VBoxContainer.get_child_count() - 1:
			vertical_index = 0
		move_cursor()
		$Move2.play()
	
	if Input.is_action_just_pressed("p%s_ui_accept" % player_id) and vertical_index == 3:
		submit()
		$Accept.play()
	


func do_action(exported_index):
		match vertical_index:
			0:
				$VBoxContainer/Panel2/PlayerIcon.texture = icons[exported_index]
			1:
				$VBoxContainer/Panel/Name.text = names[exported_index]
			2:
				$VBoxContainer/TextureRect2/PlayerColor.color = colors[exported_index]



func move_cursor():
	var control : Control = $VBoxContainer.get_child(vertical_index)
	var global_center = control.global_position + control.size / 2.0
	$Cursor.global_position = global_center


func set_player_name():
	$VBoxContainer/Panel/Name.text = names[name_index]

func set_color():
	$VBoxContainer/TextureRect2/PlayerColor.color = colors[color_index]

func set_icon():
	$VBoxContainer/Panel2/PlayerIcon.texture = icons[icon_index]



func submit():
	PlayerData.player_icons[player_id] = icons[icon_index]
	PlayerData.player_names[player_id] = names[name_index]
	PlayerData.player_colors[player_id] = colors[color_index]
	
	
	submitted = true
	
	print(PlayerData.player_icons)
	print(PlayerData.player_names)
	print(PlayerData.player_colors)
	
	$VBoxContainer.hide()
	$Cursor.hide()
	
	$Ready.show()
	
	get_parent().set_ready(player_id,true)

func unsubmit():
	submitted = false
	
	$VBoxContainer.show()
	$Cursor.show()
	
	$Accept2.play()
	$Ready.hide()
	get_parent().set_ready(player_id,false)
