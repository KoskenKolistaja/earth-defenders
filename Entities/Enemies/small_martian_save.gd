extends CharacterBody3D


var planet_pos = Vector3.ZERO
var planet_radius = 50.0
var avoid_strength = 5.0


var action_list = []


var hp = 5

var bullets = 3

var initial_direction

var speed = 1.5

var active = false

var target = null

func _ready():
	var input_dir = Vector2(initial_direction.x,initial_direction.y)
	
	var target_angle = -atan2(input_dir.x, input_dir.y)
	
	rotation.z = target_angle
	velocity = basis.y * speed


func _physics_process(delta):
	
	if active:
		move_toward_position(Vector3(0,0,0))
	
	
	
	move_and_slide()


func move_toward_position(exported_position):
	var steering = get_steering(exported_position)
	
	var direction : Vector3 = (steering - self.global_position).normalized()
	
	var direction_2d = Vector2(direction.x,direction.y)
	var basis_up = basis.y
	var basis_2d = Vector2(basis_up.x,basis_up.y)
	
	
	if direction_2d.angle_to(basis_2d) > 0:
		rotation_degrees.z -= 1
	else:
		rotation_degrees.z += 1
	
	velocity = basis.y * speed


func get_steering(target_pos: Vector3) -> Vector3:
	var desired = (target_pos - global_position).normalized()
	
	# Avoid planet
	var to_planet = global_position - planet_pos
	var dist = to_planet.length()
	if dist < planet_radius * 2.0: # start avoiding earlier than surface
		var avoid_force = to_planet.normalized() * (1.0 - dist / (planet_radius * 2.0)) * avoid_strength
		desired += avoid_force

	return desired.normalized()

func get_hit(damage : int = 5):
	hp -= damage
	if hp <= 0:
		die()


func die():
	queue_free()


func _on_activation_timer_timeout():
	$ThrustParticles.emitting = true
	active = true
	speed = 3
