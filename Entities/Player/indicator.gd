extends Control

@export var camera: Camera3D
@export var margin: float = 50.0  # Distance from screen edge

func _ready() -> void:
	# Automatically find the active 3D camera if not assigned
	if camera == null:
		camera = get_viewport().get_camera_3d()
	
	var player_id = get_parent().player_id
	
	if player_id:
		$NameLabel.text = PlayerData.player_names[player_id]
		$NameLabel.modulate = PlayerData.player_colors[player_id]


func _process(_delta: float) -> void:
	if camera == null:
		return
	
	var world_pos = get_parent().global_position
	var screen_pos = camera.unproject_position(world_pos)
	
	# If behind camera, invert to project in front
	var to_camera = camera.global_transform.origin - world_pos
	if to_camera.dot(camera.global_transform.basis.z) < 0:
		screen_pos = -screen_pos
	
	var viewport_size = get_viewport_rect().size
	
	var is_offscreen = (
		screen_pos.x < 0 or screen_pos.x > viewport_size.x or
		screen_pos.y < 0 or screen_pos.y > viewport_size.y
	)
	
	visible = is_offscreen
	if not visible:
		return
	
	var clamped_pos = screen_pos.clamp(
		Vector2(margin, margin),
		viewport_size - Vector2(margin, margin)
	)
	
	position = clamped_pos - size / 2
