extends Control

var floating_label = preload("res://Entities/UI/floating_label.tscn")


















func spawn_label(text,exported_position,color : Color = Color(0,1,0),time : float = 1.0,size : int = 10):
	var label_instance : Label = floating_label.instantiate()
	label_instance.text = text
	if typeof(exported_position) == TYPE_VECTOR3:
		label_instance.global_position = get_viewport().get_camera_3d().unproject_position(exported_position)
	else:
		label_instance.global_position = exported_position
	label_instance.time = time
	label_instance.modulate = color
	label_instance.add_theme_font_size_override("font1",size)
	add_child(label_instance)
