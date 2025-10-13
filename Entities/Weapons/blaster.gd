extends Node3D



@export var bullet : PackedScene

var loaded = true

var damage = 1

var xp = 0
var level = 1

var xp_levels = [10,20,30,40]
var xp_needed

var index = 0



func _ready():
	xp_needed = xp_levels[index]


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


func award_xp(amount : int = 1):
	xp += amount
	
	if xp >= xp_needed:
		level += 1
		index += 1
		if not xp_levels.get(index):
			return
		xp_needed = xp_levels[index]
		upgrade_weapon()

func release():
	pass

func _on_timer_timeout():
	loaded = true





func upgrade_weapon():
	
	match level:
		1:
			pass
		2:
			$Timer.wait_time = 0.15
		3:
			$Timer.wait_time = 0.1
		4:
			$Timer.wait_time = 0.05
