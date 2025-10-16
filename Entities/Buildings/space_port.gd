extends Area3D


var reserved_ships = {
	"combat_ship" : 3,
	"speeder" : 1,
}



func _ready():
	$Label.global_position = get_viewport().get_camera_3d().unproject_position(self.global_position)




func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	if not bodies:
		$Label.hide()
		return
	else:
		$Label.show()
	
	var ship = bodies[0]
	
	if Input.is_action_just_pressed("p1_reserve"):
		reserve_ship(ship)
	


func reserve_ship(ship_ref):
	var type = ship_ref.type
	var dictionary_value = reserved_ships[type]
	reserved_ships[type] = dictionary_value + 1
	
	ship_ref.player_node.ship_reserved()
	
	var hud = get_tree().get_first_node_in_group("hud")
	
	hud.erase_ship_hud(ship_ref.player_id)
	
	ship_ref.queue_free()






func spawn_ship(ship_name : String , player_id : int):
	var ship_instance = ItemData.ships[ship_name].instantiate()
	var objects = get_tree().get_first_node_in_group("objects")
	ship_instance.player_id = player_id
	
	var players = get_tree().get_nodes_in_group("player")
	
	var player_node = null
	
	for p in players:
		if p.player_id == player_id:
			player_node = p
			break
	
	if player_node:
		ship_instance.player_node = player_node
	
	player_node.ship = ship_instance
	
	var dictionary_value = reserved_ships[ship_name]
	reserved_ships[ship_name] = dictionary_value - 1
	
	objects.add_child(ship_instance)
	ship_instance.global_position = $SpawnPosition.global_position
