extends StaticBody3D


var hp = 100


var dead = false

@export var nozzle : PackedScene


func _physics_process(delta):
	
	$Pivot.rotation_degrees.z += 0.1
	
	if dead:
		move_fractures()

func _ready():
	show_hp()

func show_hp():
	$HpBar.show_hp(hp)

func move_fractures():
	var fractures = $FracturedEarth.get_children()
	
	for fracture in fractures:
		var movement_vector = fracture.global_position.normalized()
		fracture.global_position += movement_vector * 0.02

func setup_fractures():
	var fractures = $FracturedEarth.get_children()
	
	for fracture in fractures:
		var nozzle_instance = nozzle.instantiate()
		fracture.add_child(nozzle_instance)


func get_hit(damage : int = 5):
	hp -= damage
	show_hp()
	if hp <= 0 and not dead:
		die()


func die():
	$HpBar.active = false
	$HpBar.hide()
	$DeathArea.active = true
	dead = true
	$MeshInstance3D.hide()
	$CollisionShape3D.disabled = true
	$FracturedEarth.show()
	$GPUParticles3D.emitting = true
	$AudioStreamPlayer.play()
	var music : AudioStreamPlayer = get_tree().get_first_node_in_group("music")
	await get_tree().create_timer(0.5).timeout
	music.stop()
	await get_tree().create_timer(13.0).timeout
	get_parent().get_parent().process_mode = Node.PROCESS_MODE_DISABLED
