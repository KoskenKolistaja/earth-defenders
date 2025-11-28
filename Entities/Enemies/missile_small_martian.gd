extends CharacterBody3D

@export var planet_pos: Vector3 = Vector3.ZERO
@export var planet_radius: float = 15.0
@export var avoid_start_multiplier: float = 1.0   # start avoiding when dist < planet_radius * avoid_start_multiplier
@export var avoid_strength: float = 10.0
@export var rotation_speed_deg: float = 90.0     # degrees per second
@export var speed: float = 3.0

var full_speed = 3.0

var dead = false

@export var explosion : PackedScene

@export var missile : PackedScene

var hp: int = 5
var active: bool = false
# If you set initial_direction from the editor, it may be a Vector2 or Vector3.
var initial_direction = Vector3.UP

var shooting = false

var target_player

var random_position

var hit_xp = 1
var kill_xp = 20

var Audio

func _ready():
	
	Audio = get_tree().get_first_node_in_group("audio")
	
	# normalize initial direction and set initial rotation (z axis) so basis.y points toward it
	if typeof(initial_direction) == TYPE_VECTOR3:
		initial_direction = Vector2(initial_direction.x, initial_direction.y)
	initial_direction = initial_direction.normalized()
	var target_angle = -atan2(initial_direction.x, initial_direction.y) # radians
	rotation.z = target_angle
	velocity = basis.y * speed
	
	var players = get_tree().get_nodes_in_group("player_ship")
	
	if players:
		target_player = players[randi_range(0,players.size()-1)]
	
	






func _physics_process(delta: float) -> void:
	
	if dead:
		return
	
	
	if shooting:
		shoot_missile()
		shooting = false
	
	
	if active:
		if not is_instance_valid(target_player):
			get_new_player_target()
		else:
			move_toward_position(target_player.global_position, delta)
	elif random_position:
		move_toward_position(random_position, delta)
		if (self.global_position - random_position).length() < 0.5:
			random_position = null
			active = true
			$ShootCheckTimer.start()
	
	move_and_slide()

func get_new_player_target():
	var players = get_tree().get_nodes_in_group("player_ship")
	
	if not players:
		active = false
		return
	
	target_player = players[randi_range(0,players.size()-1)]


func move_toward_position(target_pos: Vector3, delta: float) -> void:
	# get_steering returns a unit world-space direction (XY plane)
	var steering: Vector3 = get_steering(target_pos)
	steering.z = 0
	if steering.length_squared() < 0.00001:
		# nothing to do
		return
	steering = steering.normalized()

	# forward vector in XY (you used basis.y as "forward" in original code)
	var forward2 = Vector2(basis.y.x, basis.y.y)
	if forward2.length_squared() == 0:
		forward2 = Vector2(0, 1)
	forward2 = forward2.normalized()

	var desired2 = Vector2(steering.x, steering.y).normalized()

	# signed angle between forward and desired: atan2(cross, dot)
	var cross = forward2.x * desired2.y - forward2.y * desired2.x
	var dot = forward2.dot(desired2)
	var angle_to_target = atan2(cross, dot) # signed radians (-pi..pi)

	# clamp turn by rotation speed (radians/sec) * delta
	var max_turn = deg_to_rad(rotation_speed_deg) * delta
	var turn = clamp(angle_to_target, -max_turn, max_turn)
	rotation.z += turn

	# set velocity along the new forward
	velocity = basis.y * speed

func get_steering(target_pos: Vector3) -> Vector3:
	# base desired = direction to the target (XY plane)
	var to_target = target_pos - global_position
	to_target.z = 0
	var desired = Vector3.ZERO
	if to_target.length_squared() > 0.00001:
		desired = to_target.normalized()

	# planet avoidance (XY)
	var to_planet = global_position - planet_pos
	to_planet.z = 0
	var dist = to_planet.length()
	var avoid_zone = planet_radius * avoid_start_multiplier
	if dist > 0.0 and dist < avoid_zone:
		# outward push
		var avoid_dir = to_planet.normalized()
		var proximity = (avoid_zone - dist) / avoid_zone # 0..1
		# tangential component so ship can slide around the planet
		var tangent = Vector3(-to_planet.y, to_planet.x, 0.0).normalized()
		# choose the tangent direction that points closer to the target
		if tangent.dot(desired) < 0:
			tangent = -tangent

		# blend target, outward push and tangent
		# tune the weights (these worked in tests)
		var blended = desired * (1.0 - proximity * 0.8) \
			+ avoid_dir * (proximity * 0.6) \
			+ tangent * (proximity * 0.4)
		if blended.length_squared() > 0.00001:
			desired = blended.normalized()
	# fallback: if desired is zero (rare), keep current facing
	return desired

func get_hit(damage: int = 5) -> void:
	
	hp -= damage
	if hp <= 0:
		die()
	elif hp < 4:
		wreck()
		Audio.play_metal_hit()

func die() -> void:
	$SmokeParticles.emitting = false
	explode()


func shoot_missile():
	
	
	if is_instance_valid(target_player):
		var objects = get_tree().get_first_node_in_group("objects")
		var missile_instance = missile.instantiate()
		missile_instance.target = target_player
		missile_instance.global_rotation = self.global_rotation
		
		missile_instance.set_speed(0.2,0.2)
		objects.add_child(missile_instance)
		missile_instance.global_position = $weapon.global_position


func wreck():
	$SmokeParticles.emitting = true
	speed *= 0.9



func explode():
	set_physics_process(false)
	if dead:
		return
	dead = true
	
	var explosion_instance = explosion.instantiate()
	get_parent().add_child(explosion_instance)
	explosion_instance.global_position = global_position

	active = false
	random_position = false
	$ShootCheckTimer.stop()
	$CollisionShape3D.disabled = true
	
	fracture()  # <-- do the breakup first

	# Then safely free other parts
	$CollisionShape3D.queue_free()
	$ThrustParticles.call_deferred("queue_free")
	$ActivationTimer.call_deferred("queue_free")
	$Area3D.call_deferred("queue_free")
	$Area3D2.call_deferred("queue_free")
	$weapon.call_deferred("queue_free")
	
	await get_tree().create_timer(50,false).timeout


func fracture():
	$FracturedSmallMartian.fracture(velocity)
	$CollisionShape3D.disabled = true
	$Cube.hide()



func _on_activation_timer_timeout() -> void:
	
	if randf_range(0,1) < 0.5:
		random_position = get_random_position()
	else:
		active = true
	
	$ThrustParticles.emitting = true
	speed = full_speed


func _on_shoot_check_timer_timeout():
	var bodies = $Area3D.get_overlapping_bodies()
	for item in bodies:
		if item.is_in_group("player_ship"):
			shooting = true
			$ShootCheckTimer.stop()
			await get_tree().create_timer(0.5,false).timeout
			random_position = get_random_position()
			shooting = false
			active = false




func get_random_position():
	var origin = Vector3(0, 0, 0)
	var distance = randi_range(40,70)
	var random_angle = randf() * TAU
	var direction = Vector3(cos(random_angle), sin(random_angle), 0)
	var target_position = origin + direction * distance
	return target_position


func _on_area_3d_2_body_entered(_body):
	die()
