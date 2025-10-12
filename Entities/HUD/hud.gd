extends Control


var time = 2025




func pause_space():
	get_parent().pause_space()


func unpause_space():
	get_parent().unpause_space()





func update_time():
	time += 1
	$Time.text = str(time)


func _on_timer_timeout():
	update_time()
