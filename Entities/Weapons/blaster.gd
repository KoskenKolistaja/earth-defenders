extends Node3D



@export var bullet : PackedScene

var loaded = true

var damage = 1

var xp_multiplier = 1
var xp = 0
var xp_needed = 50
var player_id

var index = 0


var spread = 0

var fly_time = 0.5

var bullet_velocity = 0.4

var ship_hud





func _ready():
	
	
	if player_id:
		initiate_ship_hud()
		
		var facility_spawner = get_tree().get_first_node_in_group("facility_spawner")
		xp_multiplier = facility_spawner.get_xp_multiplier()
		
		
		
		update_weapon_name()

	if name == "machine_gun":
		to_machine_gun()
	if name == "sentinel":
		to_sentinel()
	if name == "minigun":
		to_minigun()

func update_weapon_name():
	var left = false
	
	if get_parent().name == "left_weapon":
		left = true
	ship_hud.update_weapon_name(self.name,left)


func initiate_ship_hud():
	var huds = get_tree().get_nodes_in_group("ship_hud")
	
	for h in huds:
		if h.player_id == player_id:
			ship_hud = h
			break
	
	
	update_xp()


func shoot():
	if loaded:
		var bullet_instance = bullet.instantiate()
		
		var direction = (-$Barrel.global_transform.basis.z + Vector3(randf_range(-spread,spread),randf_range(-spread,spread),0)).normalized()         # reference to the weapon node
		bullet_instance.damage = damage
		bullet_instance.direction = direction
		bullet_instance.fly_time = fly_time
		bullet_instance.speed = bullet_velocity
		bullet_instance.xp_multiplier = xp_multiplier
		var world = get_tree().get_first_node_in_group("objects")
		world.add_child(bullet_instance)
		bullet_instance.global_position = $Barrel.global_position
		loaded = false
		$Timer.start()
		$AudioStreamPlayer.play()
		
		if player_id:
			bullet_instance.weapon_ref = self
			Statistics.add_bullets_fired(player_id)


func get_player_id():
	return player_id

func release():
	pass

func _on_timer_timeout():
	loaded = true



func award_xp(amount : int = 1):
	xp += amount
	
	update_xp()
	
	if xp >= xp_needed:
		xp_needed *= 3
		upgrade_weapon()


func update_xp():
	var left = false
	if get_parent().name == "left_weapon":
		left = true
	
	
	
	if is_instance_valid(ship_hud):
		ship_hud.update_xp(xp,xp_needed,left)

func upgrade_weapon():
	
	if self.name == "minigun":
		return
	
	
	xp = 0
	
	
	var left = false
	
	if get_parent().name == "left_weapon":
		left = true
	
	
	if player_id:
		var upgrade_manager = get_tree().get_first_node_in_group("upgrade_manager")
		upgrade_manager.spawn_upgrade_panel((player_id),self,left)


func to_machine_gun():
	$Timer.wait_time = 0.2
	self.name = "machine_gun"
	xp_needed = 150
	spread = 0.01
	
	fly_time = 0.7
	
	if player_id:
		update_xp()
		update_weapon_name()

func to_sentinel():
	$Timer.wait_time = 0.15
	damage = 1
	self.name = "sentinel"
	xp_needed = 450
	spread = 0.05
	bullet_velocity = 0.5
	if player_id:
		update_xp()
		update_weapon_name()

func to_martian_sentinel():
	$Timer.wait_time = 0.1
	damage = 1
	self.name = "sentinel"
	spread = 0.05
	bullet_velocity = 0.4
	fly_time = 1.5

func to_martian_machine_gun():
	$Timer.wait_time = 0.2
	self.name = "machine_gun"
	spread = 0.1
	bullet_velocity = 0.3
	fly_time = 1.5

func to_minigun():
	$Timer.wait_time = 0.08
	damage = 1
	self.name = "minigun"
	spread = 0.1
	bullet_velocity = 0.4
	
	if player_id:
		get_parent().get_parent().check_for_weapon()
	if player_id:
		update_xp()
		update_weapon_name()
