extends Node3D

@export var missile : PackedScene

var loaded = true

func shoot():
	if loaded:
		shoot_missile()


func release():
	pass

func shoot_missile():
	var objects = get_tree().get_first_node_in_group("objects")
	var missile_instance = missile.instantiate()
	missile_instance.global_rotation = self.global_rotation
	missile_instance.target = null
	missile_instance.speed = 0.4
	objects.add_child(missile_instance)
	missile_instance.global_position = self.global_position
	loaded = false
	$LoadTimer.start()

func _on_load_timer_timeout():
	loaded = true
