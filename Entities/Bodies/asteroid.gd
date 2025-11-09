extends Area3D


var velocity = Vector3.ZERO
var gravitation_strength = 0.01

@export var explosion : PackedScene

var hp = 2

var dead = false

var hit_xp = 1
var kill_xp = 5

var Audio

func _ready():
	Audio = get_tree().get_first_node_in_group("audio")
	velocity = Vector3(randf_range(-1,1),randf_range(-1,1),0)


func _physics_process(delta):
	
	rotate_fire()
	set_fire_intensity(velocity.length())
	
	if dead:
		return
	
	velocity.z = 0
	
	gravitate()
	
	global_position += velocity * delta * 0.5

func set_fire_intensity(exported_float):
	var mesh = $Fireball/Sphere
	var mat = mesh.get_active_material(0)
	if mat is ShaderMaterial:
		mat.set_shader_parameter("fire_intensity", exported_float * exported_float)


func rotate_fire():
	var target_angle = atan2(velocity.x, velocity.y)
	$Fireball.rotation_degrees.x = rad_to_deg(target_angle) - 90


func get_hit(damage : int = 1):
	Audio.play_rock_hit()
	hp -= damage
	if hp <= 0:
		die()


func die():
	
	if not dead:
		monitorable = false
		monitoring = false
		$CollisionShape3D.disabled = true
		$FracturedAsteroid.show()
		$nozzle.emitting = false
		
		$Asteroid.hide()
		$CollisionShape3D.queue_free()
		await get_tree().physics_frame
		fracture()
	
	dead = true


func fracture():
	explode()
	$Fireball.hide()
	$FracturedAsteroid.fracture(velocity * 0.5)
	
	if not dead:
		await get_tree().create_timer(50).timeout
		queue_free()

func gravitate():
	var vector = (Vector3(0,0,0) - self.global_position.normalized())
	velocity += vector * gravitation_strength
#func gravitate():
	#var center = Vector3(0, 0, 0)
	#var offset = center - global_position
	#var distance = offset.length()
#
	#if distance > 0.001: # prevent divide-by-zero
		#var direction = offset / distance
		#var force = gravitation_strength / (distance * distance)
		#velocity += direction * force


func explode():
	var explosion_instance = explosion.instantiate()
	get_parent().add_child(explosion_instance)
	explosion_instance.global_position = self.global_position

func _on_body_entered(body):
	if body.has_method("get_hit"):
		body.get_hit(5)
	die()
