extends Node3D

@export var missile : PackedScene

var xp_multiplier = 1

var target = null
var target_acquired = false

var focusing = 0

var loaded = true

var player_id

const FOCUS_TRESHOLD = 50


func _ready():
	get_parent().get_parent().check_for_weapon()


func shoot():
	if loaded:
		if not target:
			target = get_target()
		else:
			focus_target()
	

func focus_target():
	$Reticle.show()
	move_reticle(target)
	$Reticle.scale = $Reticle.scale.move_toward(Vector2(0.03,0.03),0.001)
	
	focusing += 1
	
	if not target_acquired and not $AudioStreamPlayer2.playing:
		$AudioStreamPlayer2.play()
	
	
	if focusing == FOCUS_TRESHOLD:
		$AudioStreamPlayer.play()
	
	if focusing >= FOCUS_TRESHOLD:
		target_acquired = true
		$Reticle.modulate = Color(0,1,0)

func move_reticle(exported_target):
	var camera : Camera3D = get_viewport().get_camera_3d()
	$Reticle.global_position = camera.unproject_position(exported_target.global_position)





func get_target():
	var returned = null
	var bodies : Array = $MissileArea.get_overlapping_bodies()
	var areas : Array = $MissileArea.get_overlapping_areas()
	bodies.append_array(areas)
	
	if bodies:
		returned = get_closest_item(bodies)
		$Reticle.scale = Vector2(0.06,0.06)
	
	return returned



func get_closest_item(list):
	var closest = list[0]
	
	for item in list:
		var closest_distance = (closest.global_position - self.global_position).length()
		var item_distance = (item.global_position - self.global_position).length()
		if item_distance < closest_distance:
			closest = item
	return closest



func release():
	if target_acquired:
		shoot_missile()
		loaded = false
		$Timer.start()
		$AudioStreamPlayer4.play()
	
	reset_targeting()

func shoot_missile():
	var objects = get_tree().get_first_node_in_group("objects")
	var missile_instance = missile.instantiate()
	missile_instance.global_rotation = self.global_rotation
	missile_instance.target = target
	missile_instance.xp_multiplier = xp_multiplier
	objects.add_child(missile_instance)
	missile_instance.global_position = self.global_position

func reset_targeting():
	$Reticle.modulate = Color(1,1,1)
	target_acquired = false
	target = null
	$Reticle.hide()
	focusing = 0


func _on_timer_timeout():
	loaded = true
	$AudioStreamPlayer3.play()
