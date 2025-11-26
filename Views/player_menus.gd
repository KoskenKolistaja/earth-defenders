extends HBoxContainer

@export var player_menu : PackedScene

var players_in_menu: Array[int] = []
var players_ready: Array[int] = []
var joined_players: Array[int] = []

const MAX_JOY_BUTTONS := 16
const MAX_JOY_AXES := 8

func _ready():
	Input.joy_connection_changed.connect(_on_joy_connection_changed)

func _process(_delta):
	for device_id in range(8):
		if Input.is_joy_button_pressed(device_id, JOY_BUTTON_B):
			if players_in_menu.size() == 0:
				get_parent().to_start()
				queue_free()
				return  # prevent triggering multiple times

		if _any_gamepad_input(device_id):
			_register_player(device_id)

func _any_gamepad_input(device_id: int) -> bool:
	# Detect any button press
	for button in range(MAX_JOY_BUTTONS):
		if Input.is_joy_button_pressed(device_id, JOY_BUTTON_A):
			return true

	# Detect any axis movement
	for axis in range(MAX_JOY_AXES):
		if abs(Input.get_joy_axis(device_id, axis)) > 0.3:
			return true
	
	return false

func _register_player(device_id: int):
	var player_id := device_id + 1  # make it 1-based here

	if not PlayerData.players.has(player_id):
		PlayerData.add_player(player_id)
		players_in_menu.append(player_id)
		spawn_menu(player_id)
		$Register.play()
	if players_in_menu.size() > 0:
		get_parent().hide_text()

func erase_player(player_id: int):
	PlayerData.players.erase(player_id)
	players_in_menu.erase(player_id)
	players_ready.erase(player_id)
	print(players_in_menu)
	print(players_ready)
	$Erase.play()
	


func _on_joy_connection_changed(device_id: int, connected: bool):
	var player_id := device_id + 1
	if connected:
		print("Gamepad", player_id, "connected")
	else:
		print("Gamepad", player_id, "disconnected")
		erase_player(player_id)

func spawn_menu(player_id: int):
	var menu_instance = player_menu.instantiate()
	menu_instance.player_id = player_id
	add_child(menu_instance)

func set_ready(player_id: int, is_ready: bool) -> void:
	if is_ready:
		if not players_ready.has(player_id):
			players_ready.append(player_id)
	else:
		players_ready.erase(player_id)
	
	if is_ready_to_start():
		signal_start_game()

func is_ready_to_start() -> bool:
	if players_in_menu.is_empty():
		return false
	
	for id in players_in_menu:
		if not players_ready.has(id):
			return false
	
	return true

func signal_start_game():
	get_parent().start_game()
