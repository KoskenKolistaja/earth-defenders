extends ProgressBar




func show_hp(hp):
	value = hp
	show()
	$Timer.start()



func _on_timer_timeout():
	hide()
