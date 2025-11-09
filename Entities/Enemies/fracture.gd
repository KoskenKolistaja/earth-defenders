extends Area3D

var velocity = Vector3.ZERO

var active = false

var gravitation_strength = 15.0

func activate():
	active = true
	$CollisionShape3D.disabled = false
	monitoring = true
	monitorable = true

func _ready():
	connect("area_entered", Callable(self, "_on_area_entered"))
	connect("body_entered", Callable(self, "_on_body_entered"))

func _physics_process(delta):
	velocity.z = 0.0
	global_position.z = 0.0
	if active:
		global_position += velocity * delta
		gravitate(delta)

func get_collision_shape_position():
	return $CollisionShape3D.global_position


func gravitate(delta):
	var center = Vector3(0, 0, 0)
	var offset = center - global_position
	velocity += offset.normalized() * delta


func _on_area_entered(area):
	#if area.has_method("get_hit"):
		#area.get_hit(0)
	
	queue_free()

func _on_body_entered(body):
	#if body.has_method("get_hit"):
		#body.get_hit(0)
	
	queue_free()
