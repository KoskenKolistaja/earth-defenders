extends Control


@export var purchase_selection : PackedScene
@export var ship_hud : PackedScene

var time = 2025

var money : int = 2000

var scene_start_time = 0

func _ready():
	update_money()
	scene_start_time = Time.get_ticks_msec()

func _physics_process(_delta):
	for id in PlayerData.players:
		if Input.is_action_just_pressed("p%s_ready" % id) and not MetaData.game_over:
			trigger_purchase_selection()
	
	if not MetaData.game_over:
		update_difficulty()


func game_over_pre():
	$PlayerHUDS.hide()
	
	$PanelL.hide()
	$PanelR.hide()
	
	for c in $PlayerHUDS.get_children():
		c.queue_free()




func  game_over():
	$GameOverPanel.show()
	$GameOverPanel/HBoxContainer/Restart.grab_focus()
	$GameOverPanel.initiate_stats()
	
	
	pause_space()

func trigger_purchase_selection():
	if not get_node_or_null("PurchaseSelectionPanel"):
		var selection_instance = purchase_selection.instantiate()
		add_child(selection_instance)
		pause_space()


func spawn_ship_hud(exported_id):
	
	if MetaData.game_over:
		return
	
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
	$PanelL/Money.text = "Money: " + str(money) + "$"


func update_time():
	time += 1
	$PanelC/Time.text = str(time)


func update_difficulty():
	var spawn_manager = get_tree().get_first_node_in_group("spawn_manager")
	
	var difficulty  = spawn_manager.get_difficulty(snapped(MetaData.game_time_elapsed,0.1))
	
	$PanelR/Difficulty.text = "Difficulty: " + str(difficulty)


func _on_timer_timeout():
	update_time()
	MetaData.game_time_elapsed += 2
