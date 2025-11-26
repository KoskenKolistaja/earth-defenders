extends NinePatchRect

@export var player_cursor : PackedScene

var active = false

var player_votes = {}

var starting_time

var item_votes = {
	0:0,
	1:0,
	2:0,
	3:0,
	4:0,
	5:0,
	6:0,
	7:0,
	8:0
}


func _ready():
	get_parent().pause_space()
	disable_unavailable()
	update_item_prices()
	update_facility_count()
	
	fade_in()
	
	spawn_cursors()
	await get_tree().create_timer(1).timeout
	active = true


func fade_in():
	modulate.a = 0.0
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.5)


func update_item_prices():
	var items = $ItemPricesContainer.get_children()
	
	
	for i in items:
		
		if not ItemData.item_prices.has(i.name):
			continue
		
		i.text = str(ItemData.item_prices[i.name]) + "$"

func _physics_process(_delta):
	$Time.text = str(snappedi($Timer.time_left,1))

func disable_unavailable():
	var hud = get_tree().get_first_node_in_group("hud")
	var money = hud.money
	
	for item in $HBoxContainer.get_children():
		var price = ItemData.item_prices[item.name]
		if price > money:
			item.self_modulate = Color(1,1,1,0.2)
	
	
	var facility_spawner = get_tree().get_first_node_in_group("facility_spawner")
	var has_free_slots = facility_spawner.get_free_position()
	
	if not has_free_slots:
		var children = $HBoxContainer.get_children()
		for i in range(3, 8): # 8 is excluded → gives 3,4,5,6,7
			var item = children[i]
			item.self_modulate = Color(1, 1, 1, 0.2)

func update_facility_count():
	var facility_spawner = get_tree().get_first_node_in_group("facility_spawner")
	var count = facility_spawner.get_facility_count()
	$FacilityCount.text = str(count) + "/20"


func spawn_cursors():
	for id in PlayerData.players:
		var cursor_instance = player_cursor.instantiate()
		cursor_instance.player_id = id
		add_child(cursor_instance)


func change_info(index):
	var item_name = $HBoxContainer.get_child(index).name
	var info = ItemData.item_info[item_name]
	$NinePatchRect/ItemInfo.text = info


func get_cursor_position(exported_index):
	var node : Control = $HBoxContainer.get_child(exported_index)
	var global_center = node.global_position + node.size / 2.0
	return global_center



func get_max_items() -> int:
	var item_count = $HBoxContainer.get_child_count()
	
	return item_count



func assign_vote(player_id,index):
	
	if not active:
		return
	
	var hud = get_tree().get_first_node_in_group("hud")
	var money = hud.money
	var price = ItemData.item_prices[$HBoxContainer.get_child(index).name]
	
	if price > money:
		return
	
	var facility_spawner = get_tree().get_first_node_in_group("facility_spawner")
	
	if index in range(3, 8) and not facility_spawner.get_free_position():
		return
	
	
	if $Timer.is_stopped():
		$Timer.start()
		$Time.show()
	
	if player_votes.has(player_id):
		var current_number = item_votes[player_votes[player_id]]
		item_votes[player_votes[player_id]] = current_number - 1
		$HBoxContainer.get_child(player_votes[player_id]).get_child(0).text = str(item_votes[player_votes[player_id]])
	
	player_votes[player_id] = index
	
	item_votes[index] += 1
	
	$HBoxContainer.get_child(index).get_child(0).text = str(item_votes[index])
	
	
	if player_votes.size() >= PlayerData.players.size():
		ready()




func ready():
	var item_name = null
	
	var most_voted = 6
	
	for item in item_votes:
		if item_votes[item] > item_votes[most_voted]:
			most_voted = item
	
	item_name = $HBoxContainer.get_child(most_voted).name
	
	action(item_name)
	
	get_parent().unpause_space()
	
	get_tree().call_group("ship_hud","update_selection")
	
	queue_free()


func action(item_name):
	
	
	match item_name:
		"speeder":
			add_ship_to_reserve(item_name)
		"combat_ship":
			add_ship_to_reserve(item_name)
		"old_ship":
			add_ship_to_reserve(item_name)
		"repair_station":
			add_facility(item_name)
		"shield_generator":
			add_facility(item_name)
		"geo_repair_station":
			add_facility(item_name)
		"technology_institute":
			add_facility(item_name)
		"bank":
			add_facility(item_name)
		"none":
			pass
	
	var hud = get_tree().get_first_node_in_group("hud")
	var price = ItemData.item_prices[item_name]
	
	hud.add_money(-price)

func add_ship_to_reserve(ship_name):
	var spaceport = get_tree().get_first_node_in_group("spaceport")
	spaceport.add_ship(ship_name)

func add_facility(facility_name):
	var facility_spawner = get_tree().get_first_node_in_group("facility_spawner")
	facility_spawner.add_facility(facility_name)



func _on_timer_timeout():
	ready()
