extends Area3D



var direction = Vector3.UP
var speed = 0.3


func  _ready():
	await get_tree().create_timer(1.2).timeout
	queue_free()


func _physics_process(delta):
	global_position += direction * speed
	look_at_from_position(self.global_position,self.global_position + direction * speed)

func _on_body_entered(body):
	if body.has_method("get_hit"):
		body.get_hit(1)
	queue_free()


func _on_area_entered(area):
	if area.has_method("get_hit"):
		area.get_hit(1)
	queue_free()
