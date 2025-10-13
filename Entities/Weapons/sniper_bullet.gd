extends Area3D




var direction : Vector3 = Vector3.UP
var speed : float = 0.7
var damage : int = 5

func  _ready():
	await get_tree().create_timer(1.2,false).timeout
	queue_free()


func _physics_process(delta):
	global_position += direction * speed
	look_at_from_position(self.global_position,self.global_position + direction * speed)




func _on_body_entered(body):
	if body.has_method("get_hit"):
		body.get_hit(damage)
	queue_free()


func _on_area_entered(area):
	if area.has_method("get_hit"):
		area.get_hit(damage)
	queue_free()
