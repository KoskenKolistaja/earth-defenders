extends Node3D

@export var missile : PackedScene

var loaded = true


var xp = 0
var xp_needed = 20
var xp_multiplier = 1
var player_id

var ship_hud


func _ready():
	initiate_ship_hud()
	var facility_spawner = get_tree().get_first_node_in_group("facility_spawner")
	xp_multiplier = facility_spawner.get_xp_multiplier()
	update_weapon_name()

func initiate_ship_hud():
	var huds = get_tree().get_nodes_in_group("ship_hud")
	
	for h in huds:
		if h.player_id == player_id:
			ship_hud = h
			break
	
	update_xp()

func update_weapon_name():
	var left = false
	
	if get_parent().name == "left_weapon":
		left = true
	ship_hud.update_weapon_name(self.name,left)

func update_xp():
	var left = false
	if get_parent().name == "left_weapon":
		left = true
	
	
	ship_hud.update_xp(xp,xp_needed,left)


func shoot():
	if loaded:
		shoot_missile()
		$AudioStreamPlayer.play()

func release():
	pass

func shoot_missile():
	var objects = get_tree().get_first_node_in_group("objects")
	var missile_instance = missile.instantiate()
	missile_instance.target = null
	missile_instance.speed = 0.4
	missile_instance.weapon_ref = self
	missile_instance.xp_multiplier = xp_multiplier
	objects.add_child(missile_instance)
	missile_instance.global_rotation = self.global_rotation
	missile_instance.global_position = self.global_position
	loaded = false
	$LoadTimer.start()



func award_xp(amount : int = 1):
	xp += amount
	
	update_xp()
	
	
	if xp >= xp_needed:
		upgrade_weapon()


func upgrade_weapon():
	
	xp = 0
	
	xp_needed *= 3
	
	var left = false
	
	if get_parent().name == "left_weapon":
		left = true
	
	
	var upgrade_manager = get_tree().get_first_node_in_group("upgrade_manager")
	upgrade_manager.spawn_upgrade_panel((player_id),self,left)




func _on_load_timer_timeout():
	loaded = true
