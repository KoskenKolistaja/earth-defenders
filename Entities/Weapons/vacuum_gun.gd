extends Node3D

var strength = 5

func shoot():
	var bodies = $VacuumArea.get_overlapping_areas()
	for item in bodies:
		var vector =$CollectArea.global_position - item.global_position
		var direction = vector.normalized()
		var distance = $CollectArea.global_position.distance_to(item.global_position)
		
		# Invert distance so closer objects get stronger pull
		var force = strength / max(distance, 1)  # prevent division by zero
		
		item.velocity = item.velocity.move_toward(direction * (force*2) * strength,1)

func release():
	pass


func _on_collect_area_body_entered(body):
	reward_money()
	
	
	body.queue_free()




func reward_money():
	$AudioStreamPlayer.play()


func _on_collect_area_area_entered(area):
	reward_money()
	
	
	area.queue_free()
