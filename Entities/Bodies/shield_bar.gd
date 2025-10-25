extends TextureProgressBar



var active = true


func show_shield(shield):
	if active:
		value = shield
		show()
	else:
		hide()



func _on_timer_timeout():
	hide()
