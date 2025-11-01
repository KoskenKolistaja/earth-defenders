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
	$AudioStreamPlayer.play()
	$Panel/Label.text = PlayerData.player_names[player_id]
	
	
	
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
			sniper()

# -----------------------
# UPGRADE BRANCH FUNCTIONS
# -----------------------

func blaster():
	if Input.is_action_just_pressed("p%s_ui_left" % player_id):
		upgrade_to_machine_gun()
	if Input.is_action_just_pressed("p%s_ui_right" % player_id):
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

func sentinel():
	if Input.is_action_just_pressed("p%s_ui_left" % player_id):
		upgrade_to_minigun()
	if Input.is_action_just_pressed("p%s_ui_right" % player_id):
		change_to_laser()

func vacuum_gun():
	if Input.is_action_just_pressed("p%s_ui_left" % player_id):
		change_to_planter()
	if Input.is_action_just_pressed("p%s_ui_right" % player_id):
		upgrade_to_hoover()

func rocket_launcher():
	if Input.is_action_just_pressed("p%s_ui_left" % player_id):
		change_to_missile_launcher()
	if Input.is_action_just_pressed("p%s_ui_right" % player_id):
		change_to_xxx()

func sniper():
	if Input.is_action_just_pressed("p%s_ui_left" % player_id):
		change_to_xxx()
	if Input.is_action_just_pressed("p%s_ui_right" % player_id):
		upgrade_to_super_sniper()

# -----------------------
# CHANGE FUNCTIONS (spawn new weapon)
# -----------------------

func change_to_missile_launcher():
	_change_weapon("missile_launcher")

func change_to_rocket_launcher():
	_change_weapon("rocket_launcher")

func change_to_rifle():
	_change_weapon("rifle")

func change_to_vacuum_gun():
	_change_weapon("vacuum_gun")

func change_to_laser():
	_change_weapon("laser")

func change_to_xxx():
	pass

func change_to_planter():
	_change_weapon("planter")

func _change_weapon(new_name: String):
	var players = get_tree().get_nodes_in_group("player_ship")
	var player
	for p in players:
		if p.player_id == player_id:
			player = p
			break
	if not player:
		return
	if left:
		player.change_weapon_left(new_name)
	else:
		player.change_weapon_right(new_name)
	queue_free()

# -----------------------
# UPGRADE FUNCTIONS (same weapon, internal upgrade)
# -----------------------

func upgrade_to_machine_gun():
	weapon_ref.to_machine_gun()
	queue_free()

func upgrade_to_sentinel():
	weapon_ref.to_sentinel()
	queue_free()

func upgrade_to_minigun():
	weapon_ref.to_minigun()
	queue_free()

func upgrade_to_sniper():
	weapon_ref.to_sniper()
	queue_free()

func upgrade_to_super_sniper():
	weapon_ref.to_super_sniper()
	queue_free()

func upgrade_to_hoover():
	weapon_ref.to_hoover()
	queue_free()
