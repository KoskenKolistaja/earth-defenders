extends Control


var time = 2025













func update_time():
	time += 1
	$Time.text = str(time)


func _on_timer_timeout():
	update_time()
