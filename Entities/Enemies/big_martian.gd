extends Node3D

var initial_position

var target
var spawning = false

signal target_reached

var speed = 0.05

var hp = 20

@export var ship : PackedScene

var ships = 3

func _ready():
	initial_position = self.global_position
	var vector = Vector3(0,0,0) - self.global_position
	target = -vector.limit_length(40)
	target_reached.connect(_on_target_reached)


func _physics_process(delta):
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
	hp -= damage
	if hp <= 0:
		die()


func die():
	print("Queued free from die")
	queue_free()


func _on_target_reached():
	
	print(ships)
	
	
	if ships < 1:
		print("Queued free")
		queue_free()
	
	spawning = true
	$Martian/ThrustParticles.emitting = false
	$SpawnTimer.start()
	$Martian/AnimationPlayer.play("DoorOpen")

func _on_spawn_timer_timeout():
	spawn_ship()



func spawn_ship():
	if ships:
		await get_tree().create_timer(0.5).timeout
		var ship_instance = ship.instantiate()
		ship_instance.initial_direction = -basis.x
		var objects = get_tree().get_first_node_in_group("objects")
		ship_instance.global_position = self.global_position
		objects.add_child(ship_instance)
		ships -= 1
	else:
		$Martian/AnimationPlayer.play_backwards("DoorOpen")
		spawning = false
		target = initial_position
		$Martian/ThrustParticles.emitting = true
		$SpawnTimer.stop()
