extends Control

@export var weapon_selection_panel : PackedScene


var panel_progress = {}

var ids = []


func _ready():
	
	for item in PlayerData.players:
		var panel_instance = weapon_selection_panel.instantiate()
		panel_instance.player_id = item + 1
		panel_instance.supervisor = self
		$HBoxContainer.add_child(panel_instance)
		ids.append(item + 1)
	
	await get_tree().create_timer(0.1).timeout
	get_parent().pause_space()

func player_ready(exported_id):
	
	ids.erase(exported_id)
	
	if ids.size() < 1:
		scene_ready()


func scene_ready():
	get_parent().unpause_space()
