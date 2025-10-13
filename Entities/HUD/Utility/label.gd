extends Label

@export var text_to_display: String = "War declared by the Martians"
@export var char_interval: float = 0.08	# time between characters
@export var line_pause: float = 0.5		# extra wait time after line breaks
@export var typing_sound: AudioStream = null	# assign in Inspector

var current_index: int = 0
var timer := Timer.new()
var audio_player := AudioStreamPlayer.new()
var use_line_pause: bool = false	# flag to pause *after* showing a newline


func _ready():
	start()
	await get_tree().create_timer(5,false).timeout
	hide()


func start():
	timer.wait_time = char_interval
	timer.autostart = true
	timer.one_shot = false
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)

	# Setup audio player
	if typing_sound:
		audio_player.stream = typing_sound
		add_child(audio_player)

	# Clear text at start
	text = ""
	current_index = 0
	
	timer.start()


func _on_timer_timeout() -> void:
	if current_index < text_to_display.length():
		var c := text_to_display[current_index]
		text += c
		current_index += 1

		# Only play sound if not space or newline
		if typing_sound and c != " " and c != "\n":
			audio_player.stop()
			audio_player.play()

		# If newline, set flag to pause after it
		if c == "\n":
			use_line_pause = true

		# Adjust next wait time
		if use_line_pause:
			timer.stop()
			timer.start(line_pause)
			use_line_pause = false
		else:
			timer.stop()
			timer.start(char_interval)
	else:
		# Done typing
		timer.stop()
