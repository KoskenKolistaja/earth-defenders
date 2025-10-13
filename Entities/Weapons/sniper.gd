extends Node3D


@export var sniper_bullet : PackedScene

var loaded = true







func shoot():
	if loaded:
		var bullet_instance = sniper_bullet.instantiate()
		bullet_instance.direction = -$Barrel.global_transform.basis.z
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
