extends Node3D

var strength = 2

var player_id

var xp = 0

var xp_needed = 10


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
	
	if xp >= xp_needed and not self.name == "hoover":
		to_hoover()


func upgrade_weapon():
	
	xp = 0
	
	var left = false
	
	if get_parent().name == "left_weapon":
		left = true
	
	
	var upgrade_manager = get_tree().get_first_node_in_group("upgrade_manager")
	upgrade_manager.spawn_upgrade_panel((player_id+1),self,left)




func reward_money():
	$AudioStreamPlayer.play()
	var hud = get_tree().get_first_node_in_group("hud")
	hud.add_money(10)

func _on_collect_area_area_entered(area):
	reward_money()
	award_xp(1)
	
	area.queue_free()


func to_hoover():
	strength = 5
	self.name = "hoover"
	if player_id:
		get_parent().get_parent().check_for_weapon()
