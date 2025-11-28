extends Area3D


var reserved_ships = {
	"combat_ship" : 0,
	"speeder" : 0,
	"old_ship" : 0
}

var player_weapons = {}


func _ready():
	$Label.global_position = get_viewport().get_camera_3d().unproject_position(self.global_position)




func _physics_process(_delta):
	var bodies = get_overlapping_bodies()
	if not bodies:
		$Label.hide()
		return
	else:
		$Label.show()
	
	
	for id in PlayerData.players:
		if Input.is_action_just_pressed("p%s_reserve" % id):
			
			var ship = null
			
			for item in bodies:
				if item.player_id == id:
					ship = item
					break
			
			
			
			if ship:
				
				if ship.hp == ship.max_hp:
					pass
				else:
					LabelSpawner.spawn_label("Cannot reserve a damaged ship" , self.global_position,Color(1,0,0),3,30)
					return
				
				reserve_ship(ship)
				var left_weapon = ship.get_left_weapon_name()
				var right_weapon = ship.get_right_weapon_name()
				
				
				reserve_weapons(left_weapon,right_weapon,id)

func add_ship(ship_name):
	reserved_ships[ship_name] += 1


func reserve_weapons(left_weapon,right_weapon,player_id):
	player_weapons[player_id] = {"left_weapon" : left_weapon, "right_weapon" : right_weapon}

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
	
	
	if player_weapons.has(player_id):
		if player_weapons[player_id]["left_weapon"]:
			ship_instance.stored_weapon_left = player_weapons[player_id]["left_weapon"]
		if player_weapons[player_id]["right_weapon"]:
			ship_instance.stored_weapon_right = player_weapons[player_id]["right_weapon"]
		
		player_weapons.erase(player_id)
	
	objects.add_child(ship_instance)
	ship_instance.global_position = $SpawnPosition.global_position
