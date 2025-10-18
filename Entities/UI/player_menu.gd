extends Control


var player_id

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




func _ready():
	icon_index = player_id
	name_index = player_id
	color_index = player_id


#func _process(delta):
	#if Input.is_action_just_pressed("p%s_ui_left" % player_id):
		#selected_item -= 1
		#if selected_item < 0:
			#selected_item = max_items - 1
		#$Move.play()
	#if Input.is_action_just_pressed("p%s_ui_right" % player_id):
		#selected_item += 1
		#if selected_item > max_items - 1:
			#selected_item = 0
		#$Move.play()


func _process(delta):
	if Input.is_action_just_pressed("p%s_ui_left" % player_id):
		match vertical_index:
			0:
				pass
			1:
				pass
			2:
				pass
	if Input.is_action_just_pressed("p%s_ui_right" % player_id):
		pass



func set_player_name():
	$VBoxContainer/Panel/Name.text = names[name_index]

func set_color():
	$VBoxContainer/TextureRect2/PlayerColor.color = colors[color_index]

func set_icon():
	$VBoxContainer/Panel2/PlayerIcon.texture = icons[icon_index]
