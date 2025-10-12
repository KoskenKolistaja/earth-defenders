extends Node

var joined_players: Array[int] = []

# Number of buttons and axes varies by controller, but 16 buttons + 8 axes covers most cases.
const MAX_JOY_BUTTONS := 16
const MAX_JOY_AXES := 8

func _ready():
	Input.joy_connection_changed.connect(_on_joy_connection_changed)
	print("Waiting for players to join...")


func _process(_delta):
	for device_id in range(8):  # supports up to 8 controllers
		if _any_gamepad_input(device_id):
			_register_player(device_id)

func _any_gamepad_input(device_id: int) -> bool:
	# Detect any button press
	for button in range(MAX_JOY_BUTTONS):
		if Input.is_joy_button_pressed(device_id, button):
			return true

	# Detect any axis movement
	for axis in range(MAX_JOY_AXES):
		if abs(Input.get_joy_axis(device_id, axis)) > 0.3:
			return true
	
	return false

func _register_player(device_id: int):
	PlayerData.add_player(device_id)
	$Start.show()
	$Start.grab_focus()
	$Label.text = str(PlayerData.players)


func _on_joy_connection_changed(device_id: int, connected: bool):
	if connected:
		print("Gamepad", device_id, "connected")
	else:
		print("Gamepad", device_id, "disconnected")
		joined_players.erase(device_id)


func _on_start_pressed():
	get_tree().change_scene_to_file("res://Views/main.tscn")
