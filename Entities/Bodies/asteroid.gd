extends Area3D


var velocity = Vector3.ZERO
var gravitation_strength = 0.01

@export var explosion : PackedScene

var hp = 2

func _ready():
	velocity = Vector3(randf_range(-1,1),randf_range(-1,1),0)


func _physics_process(delta):
	
	gravitate()
	
	global_position += velocity * delta

func get_hit(damage : int = 1):
	hp -= damage
	if hp <= 0:
		die()


func die():
	explode()

func gravitate():
	var vector = (Vector3(0,0,0) - self.global_position.normalized())
	velocity += vector * gravitation_strength
#func gravitate():
	#var center = Vector3(0, 0, 0)
	#var offset = center - global_position
	#var distance = offset.length()
#
	#if distance > 0.001: # prevent divide-by-zero
		#var direction = offset / distance
		#var force = gravitation_strength / (distance * distance)
		#velocity += direction * force


func explode():
	var explosion_instance = explosion.instantiate()
	get_parent().add_child(explosion_instance)
	explosion_instance.global_position = self.global_position
	queue_free()

func _on_body_entered(body):
	if body.has_method("get_hit"):
		body.get_hit(5)
	explode()
