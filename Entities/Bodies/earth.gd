extends StaticBody3D


var hp = 100


var dead = false

@export var nozzle : PackedScene


func _physics_process(delta):
	
	$Pivot.rotation_degrees.z += 0.1
	
	if dead:
		move_fractures()


func move_fractures():
	var fractures = $FracturedEarth.get_children()
	
	for fracture in fractures:
		var movement_vector = fracture.global_position.normalized()
		fracture.global_position += movement_vector * 0.005

func setup_fractures():
	var fractures = $FracturedEarth.get_children()
	
	for fracture in fractures:
		var nozzle_instance = nozzle.instantiate()
		fracture.add_child(nozzle_instance)


func get_hit(damage : int = 5):
	hp -= damage
	var hud = get_tree().get_first_node_in_group("hud")
	hud.update_earth_hp(hp)
	if hp <= 0:
		die()


func die():
	dead = true
	$MeshInstance3D.hide()
	$CollisionShape3D.disabled = true
	$FracturedEarth.show()
	
	await get_tree().create_timer(5).timeout
	get_tree().quit()
