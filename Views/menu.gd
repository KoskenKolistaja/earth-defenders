extends Control

@export var player_menu_container: PackedScene

func start_game():
	get_tree().change_scene_to_file("res://Views/main.tscn")



func to_start():
	$ButtonContainer.show()
	$ButtonContainer/PLAY.grab_focus()
	hide_text()

func hide_text():
	$PressAny.hide()

func show_text():
	$PressAny.show()

func _ready():
	MetaData.reset_settings()
	PlayerData.reset_settings()
	assign_player_controls()
	$AudioStreamPlayer.play()
	
	$ButtonContainer/PLAY.grab_focus()



func assign_player_controls():
	var base_controls = {
		"shoot_right": { "type": "axis", "index": 5 }, # RT
		"shoot_left":  { "type": "axis", "index": 4 }, # LT
		"ui_left":     { "type": "button", "index": JOY_BUTTON_DPAD_LEFT },
		"ui_right":    { "type": "button", "index": JOY_BUTTON_DPAD_RIGHT },
		"ui_up":       { "type": "button", "index": JOY_BUTTON_DPAD_UP },
		"ui_down":     { "type": "button", "index": JOY_BUTTON_DPAD_DOWN },
		"ui_accept":   { "type": "button", "index": JOY_BUTTON_A },
		"ui_return":   { "type": "button", "index": JOY_BUTTON_B },
		"ready":       { "type": "button", "index": JOY_BUTTON_START },
		"reserve":     { "type": "button", "index": JOY_BUTTON_Y }
	}

	var devices = Input.get_connected_joypads()

	for player_id in devices.size():
		var device_id = devices[player_id]

		for action_suffix in base_controls.keys():
			var action_name = "p%d_%s" % [player_id + 1, action_suffix]

			if not InputMap.has_action(action_name):
				InputMap.add_action(action_name)
			InputMap.action_erase_events(action_name)

			var info = base_controls[action_suffix]
			var event

			if info.type == "button":
				event = InputEventJoypadButton.new()
				event.button_index = info.index
				event.device = device_id
			else:
				event = InputEventJoypadMotion.new()
				event.axis = info.index
				event.axis_value = 1.0
				event.device = device_id

			InputMap.action_add_event(action_name, event)

	print("✅ Player controls assigned for %d device(s)" % devices.size())


func _on_play_pressed():
	var p_menu = player_menu_container.instantiate()
	add_child(p_menu)
	$ButtonContainer.hide()
	$ButtonContainer/PLAY/AudioStreamPlayer.play()
	show_text()







func _on_exit_pressed():
	get_tree().quit()


func _on_play_focus_exited():
	$ButtonContainer/EXIT/AudioStreamPlayer.play()


func _on_exit_focus_exited():
	$ButtonContainer/EXIT/AudioStreamPlayer.play()
