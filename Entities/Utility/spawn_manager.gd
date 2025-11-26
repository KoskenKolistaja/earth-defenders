extends Node3D


@export var asteroid : PackedScene
@export var big_martian : PackedScene
@export var small_martian : PackedScene
@export var elite_small_martian : PackedScene
@export var missile_small_martian : PackedScene

@export var difficulty_curve: Curve
@export var medium_curve: Curve
@export var easy_curve: Curve

var base_asteroid_interval = 30.0
var base_big_martian_interval = 12.0
var base_small_martian_interval = 50.0
var base_elite_small_martian_interval = 80.0
var base_missile_small_martian_interval = 100.0


var scene_start_time: int = 0


func _ready():
	scene_start_time = Time.get_ticks_msec()


func get_random_position():
	var origin = Vector3(0, 0, 0)
	var distance = 75
	var random_x = randf_range(30,50)
	var random_y = randf_range(-50,50)
	if randf_range(0,1) < 0.5:
		random_x *= -1
	
	var direction = Vector3(random_x,random_y,0).normalized()
	var target_position = origin + direction * distance
	
	return target_position

func game_over():
	$AsteroidTimer.stop()
	$SmallMartianTimer.stop()
	$BigMartianTimer.stop()
	$EliteSmallMartianTimer.stop()
	$MissileSmallMartianTimer.stop()


func get_big_ship_position():
	var origin = Vector3(0, 0, 0)
	var distance = randf_range(70,100)
	var random_angle = randf() * TAU
	var direction = Vector3(cos(random_angle), sin(random_angle), 0)
	var target_position = origin + direction * distance
	
	return target_position



#func _ready():
	#await get_tree().create_timer(212,false).timeout
	#var autolabel = get_tree().get_first_node_in_group("auto_label")
	#autolabel.add_text("Martian war fleet has arrived!")
	#spawn_war_fleet()
	#Time.get_ticks_msec()





func spawn_war_fleet():
	for i in range(6):
		spawn_big_martian()


func spawn_asteroid():
	var asteroid_instance = asteroid.instantiate()
	get_parent().add_child(asteroid_instance)
	asteroid_instance.global_position = get_random_position()

func spawn_big_martian():
	var ship_instance = big_martian.instantiate()
	ship_instance.position = get_big_ship_position()
	get_parent().add_child(ship_instance)

func spawn_small_martian():
	var ship_instance = small_martian.instantiate()
	ship_instance.initial_direction = -basis.x
	var objects = get_tree().get_first_node_in_group("objects")
	objects.add_child(ship_instance)
	ship_instance.global_position = get_random_position()

func spawn_elite_small_martian():
	var ship_instance = elite_small_martian.instantiate()
	ship_instance.initial_direction = -basis.x
	var objects = get_tree().get_first_node_in_group("objects")
	objects.add_child(ship_instance)
	ship_instance.global_position = get_random_position()

func spawn_missile_small_martian():
	var ship_instance = missile_small_martian.instantiate()
	ship_instance.initial_direction = -basis.x
	var objects = get_tree().get_first_node_in_group("objects")
	objects.add_child(ship_instance)
	ship_instance.global_position = get_random_position()

func get_spawn_interval(base: float) -> float:
	var difficulty = get_difficulty(MetaData.game_time_elapsed)
	return base / (1.0 + difficulty * 0.5)


func get_difficulty(t: float) -> float: # Time in seconds
	
	if t > 3600:
		return t * 0.05
	
	var normalized_time = clamp(t / 3600.0, 0.0, 1.0)  # 5 min full scale
	return difficulty_curve.sample(normalized_time * ((cos(normalized_time * 120)) + 1) * 0.5) * 50


func _on_asteroid_timer_timeout():
	$AsteroidTimer.wait_time = get_spawn_interval(base_asteroid_interval)
	spawn_asteroid()
	$AsteroidTimer.start()


func _on_small_martian_timer_timeout():
	
	var elapsed = Time.get_ticks_msec() - scene_start_time
	
	if get_difficulty(elapsed * 0.001) > 30 and randf_range(0,100) > 50:
		spawn_elite_small_martian()
	else:
		spawn_small_martian()
	
	
	$SmallMartianTimer.wait_time = get_spawn_interval(base_small_martian_interval)
	$SmallMartianTimer.start()

func _on_big_martian_timer_timeout():
	$BigMartianTimer.wait_time = get_spawn_interval(base_big_martian_interval)
	spawn_big_martian()
	$BigMartianTimer.start()


func _on_missile_small_martian_timer_timeout():
	
	$MissileSmallMartianTimer.start()
	
	var elapsed = Time.get_ticks_msec() - scene_start_time
	
	if not get_difficulty(elapsed * 0.001) > 5:
		print("returned")
		return
	
	$MissileSmallMartianTimer.wait_time = get_spawn_interval(base_missile_small_martian_interval)
	spawn_missile_small_martian()


func _on_elite_small_martian_timer_timeout():
	
	$EliteSmallMartianTimer.start()
	
	var elapsed = Time.get_ticks_msec() - scene_start_time
	
	if not get_difficulty(elapsed * 0.001) > 5:
		print("returned")
		return
	
	$EliteSmallMartianTimer.wait_time = get_spawn_interval(base_elite_small_martian_interval)
	spawn_elite_small_martian()
