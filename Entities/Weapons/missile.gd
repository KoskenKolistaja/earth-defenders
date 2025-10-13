extends Area3D

var homing = false
var target
var turn_speed = 1
var speed = 0.3
var initial_speed = 0.2
var acceleration = 0.1

@export var explosion : PackedScene

func _ready():
	await get_tree().create_timer(5,false).timeout
	explode()



func _physics_process(delta):
	if not homing:
		initial_speed = move_toward(initial_speed,0,0.01)
	else:
		$CollisionShape3D.disabled = false
		$ThrustParticles.emitting = true
		initial_speed = move_toward(initial_speed,speed,acceleration)
	global_position += basis.y * initial_speed
	
	if target and homing:
		var direction : Vector3 = (target.global_position - self.global_position).normalized()
		
		var direction_2d = Vector2(direction.x,direction.y)
		var basis_up = basis.y
		var basis_2d = Vector2(basis_up.x,basis_up.y)
		
		
		if direction_2d.angle_to(basis_2d) > 0:
			rotation_degrees.z -= 1
		else:
			rotation_degrees.z += 1


func _on_area_entered(area):
	if area.has_method("get_hit"):
		area.get_hit(5)
	explode()


func _on_body_entered(body):
	if body.has_method("get_hit"):
		body.get_hit(5)
	explode()




func explode():
	var explosion_instance = explosion.instantiate()
	get_parent().add_child(explosion_instance)
	explosion_instance.global_position = self.global_position
	queue_free()


func _on_homing_timer_timeout():
	homing = true
	$AudioStreamPlayer.play()
