extends Node3D

var strength = 2

var player_id

var xp = 0
var xp_multiplier = 1
var xp_needed = 100

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


func update_xp():
	var left = false
	if get_parent().name == "left_weapon":
		left = true
	
	
	ship_hud.update_xp(xp,xp_needed,left)



func shoot():
	var bodies = $VacuumArea.get_overlapping_areas()
	
	$GPUParticles3D.emitting = true
	
	for item in bodies:
		var vector :Vector3=$CollectArea.global_position - item.global_position
		var direction = vector.normalized()
		var distance = $CollectArea.global_position.distance_to(item.global_position)
		
		# Invert distance so closer objects get stronger pull
		var force = strength / max(distance, 1)  # prevent division by zero
		
		item.velocity += direction * force * 0.5
		item.velocity = item.velocity.move_toward(item.velocity.limit_length(10),1)








func release():
	$GPUParticles3D.emitting = false


func _on_collect_area_body_entered(body):
	reward_money()
	
	
	body.queue_free()


func award_xp(amount : int = 1):
	xp += amount
	
	update_xp()
	
	if xp >= xp_needed and not self.name == "hoover":
		upgrade_weapon()

func update_weapon_name():
	var left = false
	
	if get_parent().name == "left_weapon":
		left = true
	ship_hud.update_weapon_name(self.name,left)

func upgrade_weapon():
	
	xp = 0
	
	var left = false
	
	if get_parent().name == "left_weapon":
		left = true
	
	
	var upgrade_manager = get_tree().get_first_node_in_group("upgrade_manager")
	upgrade_manager.spawn_upgrade_panel((player_id),self,left)




func reward_money():
	$AudioStreamPlayer.play()
	var hud = get_tree().get_first_node_in_group("hud")
	hud.add_money(10)

func _on_collect_area_area_entered(area):
	reward_money()
	award_xp(1 * xp_multiplier)
	
	area.queue_free()


func to_hoover():
	strength = 5
	self.name = "hoover"
	if player_id:
		get_parent().get_parent().check_for_weapon()
	update_weapon_name()
