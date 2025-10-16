extends Control



var weapon_name

var weapon_ref
var player_id
var left = true


@export var machine_gun_icon : Texture
@export var rifle_icon : Texture
@export var sentinel_icon : Texture
@export var vacuum_gun_icon : Texture
@export var rocket_launcher_icon : Texture
@export var sniper_icon : Texture
@export var minigun_icon : Texture
@export var laser_icon : Texture
@export var planter_icon : Texture
@export var hoover_icon : Texture
@export var missile_launcher_icon : Texture
@export var xxx_icon : Texture
@export var super_sniper_icon : Texture


func _physics_process(delta):
	initiate_selection(weapon_ref.name)



func _ready():
	var weapon_name = weapon_ref.name
	
	match weapon_name:
		"blaster":
			$Panel/HBoxContainer/TextureLeft.texture = machine_gun_icon
			$Panel/HBoxContainer/TextureRight.texture = rifle_icon
		"machine_gun":
			$Panel/HBoxContainer/TextureLeft.texture = sentinel_icon
			$Panel/HBoxContainer/TextureRight.texture = vacuum_gun_icon
		"rifle":
			$Panel/HBoxContainer/TextureLeft.texture = rocket_launcher_icon
			$Panel/HBoxContainer/TextureRight.texture = sniper_icon
		"sentinel":
			$Panel/HBoxContainer/TextureLeft.texture = minigun_icon
			$Panel/HBoxContainer/TextureRight.texture = laser_icon
		"vacuum_gun":
			$Panel/HBoxContainer/TextureLeft.texture = planter_icon
			$Panel/HBoxContainer/TextureRight.texture = hoover_icon
		"rocket_launcher":
			$Panel/HBoxContainer/TextureLeft.texture = missile_launcher_icon
			$Panel/HBoxContainer/TextureRight.texture = xxx_icon
		"sniper":
			$Panel/HBoxContainer/TextureLeft.texture = xxx_icon
			$Panel/HBoxContainer/TextureRight.texture = super_sniper_icon



func initiate_selection(weapon_name):
	
	print("initate_selection")
	print(weapon_name)
	
	match weapon_name:
		"blaster":
			blaster()
		"machine_gun":
			machine_gun()
		"rifle":
			rifle()
		"sentinel":
			sentinel()
		"vacuum_gun":
			vacuum_gun()
		"rocket_launcher":
			rocket_launcher()
		"sniper":
			pass








func blaster():
	
	print("Blasterin sisällä")
	
	print(player_id)
	
	if Input.is_action_just_pressed("p%s_ui_left" % player_id):
		upgrade_to_machine_gun()
		print("left_presed")
	if Input.is_action_just_pressed("p%s_ui_right" % player_id):
		print("right_presed")
		change_to_rifle()

func machine_gun():
	if Input.is_action_just_pressed("p%s_ui_left" % player_id):
		upgrade_to_sentinel()
	if Input.is_action_just_pressed("p%s_ui_right" % player_id):
		change_to_vacuum_gun()

func rifle():
	if Input.is_action_just_pressed("p%s_ui_left" % player_id):
		change_to_rocket_launcher()
	if Input.is_action_just_pressed("p%s_ui_right" % player_id):
		upgrade_to_sniper()


func rocket_launcher():
	if Input.is_action_just_pressed("p%s_ui_left" % player_id):
		change_to_missile_launcher()
	if Input.is_action_just_pressed("p%s_ui_right" % player_id):
		pass



func change_to_missile_launcher():
	var players = get_tree().get_nodes_in_group("player_ship")
	var player
	
	for p in players:
		if p.player_id == player_id:
			player = p
	
	if not player:
		return
	
	if left:
		player.change_weapon_left("missile_launcher")
	else:
		player.change_weapon_right("missile_launcher")
	
	queue_free()



func change_to_rocket_launcher():
	var players = get_tree().get_nodes_in_group("player_ship")
	var player
	
	for p in players:
		if p.player_id == player_id:
			player = p
	
	if not player:
		return
	
	if left:
		player.change_weapon_left("rocket_launcher")
	else:
		player.change_weapon_right("rocket_launcher")
	
	queue_free()

func upgrade_to_sniper():
	weapon_ref.to_sniper()
	queue_free()


func upgrade_to_sentinel():
	weapon_ref.to_sentinel()
	queue_free()

func change_to_vacuum_gun():
	var players = get_tree().get_nodes_in_group("player_ship")
	var player
	
	for p in players:
		if p.player_id == player_id:
			player = p
	
	if not player:
		return
	
	if left:
		player.change_weapon_left("vacuum_gun")
	else:
		player.change_weapon_right("vacuum_gun")
	
	queue_free()


func upgrade_to_machine_gun():
	weapon_ref.to_machine_gun()
	queue_free()

func change_to_rifle():
	var players = get_tree().get_nodes_in_group("player_ship")
	var player
	
	for p in players:
		if p.player_id == player_id:
			player = p
	
	if not player:
		return
	
	if left:
		player.change_weapon_left("rifle")
	else:
		player.change_weapon_right("rifle")
	
	
	queue_free()
