extends CharacterBody3D

@export var player_id : int
@export var player_color : Color

@export var explosion : PackedScene

@export var stored_weapon_left : String
@export var stored_weapon_right : String

@export var hp : int = 100
@export var speed : float = 1.0

var turn_speed = 0.05

var gravitation_strength = 0.02










func _ready():
	$Pivot/Spaceship/ShipMesh.get_surface_override_material(3).albedo_color = player_color
	$Pivot/Spaceship/ShipMesh.get_surface_override_material(3).emission = player_color
	
	await get_tree().physics_frame
	initiate_weapons()

func _physics_process(delta):
	handle_movement()
	handle_actions()
	
	
	gravitate()
	
	move_and_slide()


func check_for_weapon():
	if $left_weapon.get_children().size() < 1:
		var autolabel = get_tree().get_first_node_in_group("auto_label")
		
		autolabel.text_to_display = "Player " + str(player_id) + " awarded with secondary weapon!"
		autolabel.start()
		change_weapon_left("blaster")



func initiate_weapons():
	change_weapon_left(stored_weapon_left)
	change_weapon_right(stored_weapon_right)

func change_weapon_left(weapon_name : String):
	
	if not ItemData.weapons.has(weapon_name):
		return
	
	var weapons = $left_weapon.get_children()
	for item in weapons:
		item.queue_free()
	
	var weapon_instance = ItemData[weapon_name].instantiate()
	weapon_instance.player_id = player_id
	$left_weapon.add_child(weapon_instance)

func change_weapon_right(weapon_name : String):
	
	if not ItemData.weapons.has(weapon_name):
		return
	
	var weapons = $right_weapon.get_children()
	for item in weapons:
		item.queue_free()
	var weapon_instance = ItemData[weapon_name].instantiate()
	weapon_instance.player_id = player_id
	$right_weapon.add_child(weapon_instance)


func handle_actions():
	var left_weapon = $left_weapon.get_child(0) if $left_weapon.get_child_count() > 0 else null
	var right_weapon = $right_weapon.get_child(0) if $right_weapon.get_child_count() > 0 else null
	
	if left_weapon:
		if Input.is_action_pressed("p%s_shoot_left" % player_id):
			left_weapon.shoot()
		elif Input.is_action_just_released("p%s_shoot_left" % player_id):
			left_weapon.release()
			
	if right_weapon:
		if Input.is_action_pressed("p%s_shoot_right" % player_id):
			right_weapon.shoot()
		elif Input.is_action_just_released("p%s_shoot_right" % player_id):
			right_weapon.release()

func get_hit(damage : int = 100):
	hp -= damage
	if hp <= 0:
		die()

func heal(amount):
	hp += amount
	hp = clamp(hp,-100,100)



func die():
	explode()


func explode():
	
	var explosion_instance = explosion.instantiate()
	get_parent().add_child(explosion_instance)
	explosion_instance.global_position = global_position
	
	
	queue_free()



#func gravitate():
	#var center = Vector3(0, 0, 0)
	#var offset = center - global_position
	#var distance = offset.length()
#
	#if distance > 0.001: # prevent divide-by-zero
		#var direction = offset / distance
		#var force = gravitation_strength / (distance * distance)
		#velocity += direction * force

func gravitate():
	var vector = (Vector3(0,0,0) - self.global_position.normalized())
	velocity += vector * gravitation_strength


func handle_movement():
	#var throttle = Input.get_joy_axis(player_id, JOY_AXIS_TRIGGER_RIGHT)

	var input_dir = Vector2(
		Input.get_joy_axis(player_id-1, JOY_AXIS_LEFT_X),
		-Input.get_joy_axis(player_id-1, JOY_AXIS_LEFT_Y)
	)
	
	var input_dir_r = Vector2(
		Input.get_joy_axis(player_id-1, JOY_AXIS_RIGHT_X),
		-Input.get_joy_axis(player_id-1, JOY_AXIS_RIGHT_Y)
	)
	
	var throttle = input_dir.length()
	
	if Input.is_joy_button_pressed(player_id-1,JOY_BUTTON_A):
		throttle = 1
		$Pivot/Spaceship/ThrustParticles.emitting = true
		var light = $Pivot/Spaceship/ThrustParticles/ThrustLight
		light.omni_range = move_toward(light.omni_range,5,0.5)
	else:
		throttle = 0
		$Pivot/Spaceship/ThrustParticles.emitting = false
		var light = $Pivot/Spaceship/ThrustParticles/ThrustLight
		light.omni_range = move_toward(light.omni_range,0,0.5)
	
	
	
	velocity += basis.y * throttle * 0.1 * speed
	
	if input_dir.length() > 0.3:
		input_dir = input_dir.normalized()
		
		var target_angle = -atan2(input_dir.x, input_dir.y)
		var prev_angle = rotation.z

		# Smoothly rotate the ship toward the target angle
		rotation.z = lerp_angle(rotation.z, target_angle, turn_speed)

		# Determine rotation direction (positive = left, negative = right)
		var angular_diff = wrapf(target_angle - prev_angle, -PI, PI)

		# Smoothly tilt the pivot based on turning direction
		var tilt_target = -clamp(angular_diff * 200.0, -60.0, 60.0)
		$Pivot.rotation_degrees.y = move_toward($Pivot.rotation_degrees.y, tilt_target, 2.0)
	
	
	if input_dir_r.length() > 0.3:
		input_dir_r = input_dir_r.normalized()
		
		var target_angle = -atan2(input_dir_r.x, input_dir_r.y)
		var prev_angle = rotation.z

		# Smoothly rotate the ship toward the target angle
		rotation.z = lerp_angle(rotation.z, target_angle, turn_speed)

		# Determine rotation direction (positive = left, negative = right)
		var angular_diff = wrapf(target_angle - prev_angle, -PI, PI)

		# Smoothly tilt the pivot based on turning direction
		var tilt_target = -clamp(angular_diff * 200.0, -60.0, 60.0)
		$Pivot.rotation_degrees.y = move_toward($Pivot.rotation_degrees.y, tilt_target, 2.0)
	
	else:
		# Return to neutral tilt
		$Pivot.rotation_degrees.y = move_toward($Pivot.rotation_degrees.y, 0, 2.0)
