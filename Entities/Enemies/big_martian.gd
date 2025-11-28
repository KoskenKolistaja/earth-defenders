extends Node3D

var initial_position

var target
var spawning = false

signal target_reached

var speed = 0.05

var hp = 20

@export var ship : PackedScene
@export var explosion : PackedScene

var ships = 3

var hit_xp = 1
var kill_xp = 50

var Audio

func _ready():
	Audio = get_tree().get_first_node_in_group("audio")
	
	
	initial_position = global_position
	var planet_pos = Vector3.ZERO
	var direction = (Vector3.ZERO - global_position)  # vector pointing toward origo
	target = global_position + direction * 0.7    # move halfway toward origo
	
	
	
	target_reached.connect(_on_target_reached)


func get_spawn_position(radius: float = 80.0) -> Vector3:
	var angle = randf() * TAU  # random angle 0..2π
	var x = cos(angle) * radius
	var y = sin(angle) * radius
	return Vector3(x, y, 0.0)


func _physics_process(_delta):
	if global_position.x < 0:
		$Martian.rotation_degrees.y = -90
	else:
		$Martian.rotation_degrees.y = 90
	
	
	if not spawning:
		global_position += basis.y * speed
		var direction : Vector3 = (target - self.global_position).normalized()
		
		var direction_2d = Vector2(direction.x,direction.y)
		var basis_up = basis.y
		var basis_2d = Vector2(basis_up.x,basis_up.y)
		
		
		if direction_2d.angle_to(basis_2d) > 0:
			rotation_degrees.z -= 1
		else:
			rotation_degrees.z += 1
		
		if (self.global_position - target).length() < 0.1:
			target_reached.emit()


func get_hit(damage : int = 5):
	Audio.play_metal_hit()
	hp -= damage
	if hp <= 0:
		die()


func die():
	var explosion_instance = explosion.instantiate()
	get_parent().add_child(explosion_instance)
	explosion_instance.global_position = global_position
	
	queue_free()


func _on_target_reached():
	
	
	
	if ships < 1:
		queue_free()
	
	spawning = true
	$Martian/ThrustParticles.emitting = false
	$SpawnTimer.start()
	$Martian/AnimationPlayer.play("DoorOpen")

func _on_spawn_timer_timeout():
	spawn_ship()



func spawn_ship():
	if ships:
		await get_tree().create_timer(0.5,false).timeout
		var ship_instance = ship.instantiate()
		if global_position.x < 0:
			ship_instance.initial_direction = basis.x
		else:
			ship_instance.initial_direction = -basis.x
		var objects = get_tree().get_first_node_in_group("objects")
		objects.add_child(ship_instance)
		ship_instance.global_position = self.global_position
		ships -= 1
	else:
		$Martian/AnimationPlayer.play_backwards("DoorOpen")
		spawning = false
		target = initial_position
		$Martian/ThrustParticles.emitting = true
		$SpawnTimer.stop()
