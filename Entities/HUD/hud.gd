extends Control


@export var purchase_selection : PackedScene
@export var ship_hud : PackedScene

var time = 2025

var money : int = 500


func _ready():
	update_money()


func _physics_process(delta):
	for id in PlayerData.players:
		if Input.is_action_just_pressed("p%s_ready" % id):
			trigger_purchase_selection()

func trigger_purchase_selection():
	if not get_node_or_null("PurchaseSelectionPanel"):
		var selection_instance = purchase_selection.instantiate()
		add_child(selection_instance)
		pause_space()


func spawn_ship_hud(exported_id):
	var hud_instance = ship_hud.instantiate()
	hud_instance.player_id = exported_id
	$PlayerHUDS.add_child(hud_instance)

func erase_ship_hud(exported_id):
	var huds = $PlayerHUDS.get_children()
	
	for h in huds:
		if h.player_id == exported_id:
			h.queue_free()
			break


func pause_space():
	get_parent().pause_space()


func unpause_space():
	get_parent().unpause_space()




func add_money(amount : int):
	money += amount
	update_money()

func update_money():
	$Money.text = "Money: " + str(money) + "$"


func update_time():
	time += 1
	$Time.text = str(time)


func _on_timer_timeout():
	update_time()
	MetaData.game_time_elapsed += 2
