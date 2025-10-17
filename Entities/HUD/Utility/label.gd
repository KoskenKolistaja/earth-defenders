extends Label

@export var char_interval: float = 0.08       # time between characters
@export var line_pause: float = 0.5           # extra wait time after line breaks
@export var typing_sound: AudioStream = null  # optional sound per character
@export var post_text_pause: float = 2.0      # how long text stays before clearing

var _texts: Array[String] = []                # queue of texts to display
var _current_text: String = ""
var _current_index: int = 0
var _is_displaying: bool = false
var _use_line_pause: bool = false

var _timer := Timer.new()
var _audio := AudioStreamPlayer.new()

func _ready() -> void:
	add_child(_timer)
	add_child(_audio)

	_timer.one_shot = true
	_timer.timeout.connect(_on_timer_timeout)

	if typing_sound:
		_audio.stream = typing_sound

	hide()

func add_text(new_text: String) -> void:
	
	_texts.append(new_text)
	if not _is_displaying:
		_process_next_text()

func _process_next_text() -> void:
	if _texts.is_empty():
		hide()
		_is_displaying = false
		return

	_is_displaying = true
	show()

	_current_text = _texts.pop_front()
	_current_index = 0
	text = ""
	_timer.start(char_interval)

func _on_timer_timeout() -> void:
	if _current_index < _current_text.length():
		var c := _current_text[_current_index]
		text += c
		_current_index += 1

		if typing_sound and c != " " and c != "\n":
			_audio.stop()
			_audio.play()

		if c == "\n":
			_use_line_pause = true

		if _use_line_pause:
			_timer.start(line_pause)
			_use_line_pause = false
		else:
			_timer.start(char_interval)
	else:
		# Finished showing one text
		await get_tree().create_timer(post_text_pause).timeout
		text = ""
		_process_next_text()
