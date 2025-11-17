extends Label

var time = 1


func _ready():
	modulate.a = 1.0
	
	
	
	
	
	await get_tree().create_timer(time).timeout
	queue_free()


func _physics_process(_delta):
	global_position.y -= 0.1
