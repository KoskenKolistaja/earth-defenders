extends Node3D



@export var bullet : PackedScene

var loaded = true

var damage = 1

var xp = 0

var xp_needed = 2

var index = 0

var player_id




func shoot():
	if loaded:
		var bullet_instance = bullet.instantiate()
		
		var direction = (-$Barrel.global_transform.basis.z + Vector3(randf_range(-0.1,0.1),randf_range(-0.1,0.1),0)).normalized()
		bullet_instance.shooter = self.get_parent() # the ship that fired
		bullet_instance.weapon_ref = self           # reference to the weapon node
		bullet_instance.damage = damage
		bullet_instance.direction = direction
		var world = get_tree().get_first_node_in_group("objects")
		world.add_child(bullet_instance)
		bullet_instance.global_position = $Barrel.global_position
		loaded = false
		$Timer.start()
		$AudioStreamPlayer.play()



func release():
	pass

func _on_timer_timeout():
	loaded = true



func award_xp(amount : int = 1):
	xp += amount
	
	
	if self.name == "sentinel":
		to_minigun()
		return
	if self.name == "minigun":
		return
	
	if xp >= xp_needed:
		upgrade_weapon()


func upgrade_weapon():
	
	xp = 0
	
	var left = false
	
	if get_parent().name == "left_weapon":
		left = true
	
	
	var upgrade_manager = get_tree().get_first_node_in_group("upgrade_manager")
	upgrade_manager.spawn_upgrade_panel((player_id+1),self,left)


func to_machine_gun():
	$Timer.wait_time = 0.15
	self.name = "machine_gun"

func to_sentinel():
	$Timer.wait_time = 0.1
	damage = 2
	self.name = "sentinel"

func to_minigun():
	$Timer.wait_time = 0.04
	damage = 1
	self.name = "minigun"
