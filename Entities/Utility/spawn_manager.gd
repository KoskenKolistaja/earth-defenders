extends Node3D


@export var asteroid : PackedScene
@export var big_martian : PackedScene
@export var small_martian : PackedScene

func get_random_position():
	var origin = Vector3(0, 0, 0)
	var distance = 70
	var random_angle = randf() * TAU
	var direction = Vector3(cos(random_angle), sin(random_angle), 0)
	var target_position = origin + direction * distance
	
	return target_position


func get_big_ship_position():
	var origin = Vector3(0, 0, 0)
	var distance = randf_range(70,100)
	var random_angle = randf() * TAU
	var direction = Vector3(cos(random_angle), sin(random_angle), 0)
	var target_position = origin + direction * distance
	
	return target_position



func _ready():
	recursive_spawn()
	
	
	await get_tree().create_timer(212).timeout
	spawn_war_fleet()



func recursive_spawn():
	spawn_asteroid()
	
	
	if randf_range(0,1) < 0.2:
		spawn_small_martian()
	
	if randf_range(0,1) < 0.05:
		spawn_big_martian()
	
	await get_tree().create_timer(5).timeout
	recursive_spawn()


func spawn_war_fleet():
	for i in range(6):
		spawn_big_martian()


func spawn_asteroid():
	var asteroid_instance = asteroid.instantiate()
	get_parent().add_child(asteroid_instance)
	asteroid_instance.global_position = get_random_position()

func spawn_big_martian():
	var ship_instance = big_martian.instantiate()
	ship_instance.global_position = get_big_ship_position()
	get_parent().add_child(ship_instance)
	print(ship_instance)

func spawn_small_martian():
	var ship_instance = small_martian.instantiate()
	ship_instance.initial_direction = -basis.x
	var objects = get_tree().get_first_node_in_group("objects")
	ship_instance.global_position = get_random_position()
	objects.add_child(ship_instance)
