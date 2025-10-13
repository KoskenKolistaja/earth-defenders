extends Node3D

var target = null

var hp = 5



func _physics_process(delta):
	if target:
		$GPUParticles3D/GPUParticlesAttractorSphere3D.global_position = target.global_position
		$GPUParticles3D.emitting = true
	else:
		$GPUParticles3D.emitting = false


func get_hit(damage : int = 1):
	hp -= damage
	if hp < 1:
		queue_free()



func _on_timer_timeout():
	if target:
		target.heal(1)


func _on_area_3d_body_entered(body):
	target = body



func _on_area_3d_body_exited(body):
	if body == target:
		target = null
