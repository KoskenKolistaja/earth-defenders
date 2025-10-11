extends ProgressBar

var active = true


func show_hp(hp):
	if active:
		value = hp
		show()
		$Timer.start()
	else:
		hide()



func _on_timer_timeout():
	hide()
