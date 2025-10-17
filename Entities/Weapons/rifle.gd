extends Node3D


@export var rifle_bullet : PackedScene

var loaded = true

var player_id

var bullet_velocity = 0.3
var bullet_damage = 2

var penetration = false

var xp = 0
var xp_needed = 10
var xp_multiplier = 1

var fly_time = 1.2

@export var rifle_sound : AudioStream

var ship_hud

func _ready():
	initiate_ship_hud()


func initiate_ship_hud():
	var huds = get_tree().get_nodes_in_group("ship_hud")
	
	for h in huds:
		if h.player_id == player_id:
			ship_hud = h
			break
	
	update_xp()


func update_xp():
	var left = false
	if get_parent().name == "left_weapon":
		left = true
	
	var amount = snappedi(float(xp) / float(xp_needed) * 100, 1)
	
	if is_instance_valid(ship_hud):
		ship_hud.update_xp(amount,left)

func shoot():
	if loaded:
		var bullet_instance = rifle_bullet.instantiate()
		bullet_instance.direction = -$Barrel.global_transform.basis.z
		var world = get_tree().get_first_node_in_group("objects")
		bullet_instance.weapon_ref = self
		bullet_instance.penetration = penetration
		bullet_instance.fly_time = fly_time
		bullet_instance.xp_multiplier = xp_multiplier
		world.add_child(bullet_instance)
		bullet_instance.speed = bullet_velocity
		bullet_instance.damage = bullet_damage
		bullet_instance.global_position = $Barrel.global_position
		loaded = false
		$Timer.start()
		$AudioStreamPlayer.play()


func award_xp(amount : int = 1):
	if self.name == "super_sniper":
		return
	xp += amount
	
	update_xp()
	
	if xp >= xp_needed:
		xp_needed *= 2
		upgrade_weapon()


func upgrade_weapon():
	
	xp = 0
	
	var left = false
	
	if get_parent().name == "left_weapon":
		left = true
	
	
	var upgrade_manager = get_tree().get_first_node_in_group("upgrade_manager")
	upgrade_manager.spawn_upgrade_panel((player_id),self,left)


func to_sniper():
	$Timer.wait_time = 0.5
	bullet_velocity = 0.7
	bullet_damage = 5
	self.name = "sniper"
	$AudioStreamPlayer.stream = rifle_sound

func to_super_sniper():
	$Timer.wait_time = 0.4
	bullet_velocity = 1
	bullet_damage = 5
	penetration = true
	self.name = "super_sniper"
	fly_time = 5
	$AudioStreamPlayer.stream = rifle_sound
	get_parent().get_parent().check_for_weapon()

func release():
	pass

func _on_timer_timeout():
	loaded = true
