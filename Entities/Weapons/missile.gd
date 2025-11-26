extends Area3D

var homing = false
var target
var turn_speed = 1
var speed = 0.3
var initial_speed = 0.3
var acceleration = 0.1

@export var explosion : PackedScene

var xp_multiplier = 1

var shooter
var weapon_ref

var damage = 5

var exploded = false

func _ready():
	await get_tree().create_timer(5,false).timeout
	explode()



func _physics_process(_delta):
	if not homing:
		initial_speed = move_toward(initial_speed,0,0.01)
	else:
		$CollisionShape3D.disabled = false
		$ThrustParticles.emitting = true
		initial_speed = move_toward(initial_speed,speed,acceleration)
	global_position += basis.y * initial_speed
	
	if target and homing:
		var direction : Vector3 = (target.global_position - self.global_position).normalized()
		
		var direction_2d = Vector2(direction.x,direction.y)
		var basis_up = basis.y
		var basis_2d = Vector2(basis_up.x,basis_up.y)
		
		
		if direction_2d.angle_to(basis_2d) > 0:
			rotation_degrees.z -= 1
		else:
			rotation_degrees.z += 1


func set_speed(amount,amount2):
	speed = amount
	initial_speed = amount2


func _on_area_entered(area):
	if exploded:
		print("returned")
		return
	
	if area.has_method("get_hit"):
		area.get_hit(damage)
		if area.is_in_group("xp"):
			if area.hp <= 0:
				if weapon_ref:
					var award_xp = area.kill_xp * xp_multiplier
					weapon_ref.award_xp(award_xp)
					LabelSpawner.spawn_label("+" + str(award_xp) + "xp",self.global_position)
					var hud = get_tree().get_first_node_in_group("hud")
					hud.add_money(50)
					var player_id = weapon_ref.get_player_id()
					if player_id:
						Statistics.add_asteroids_destroyed(player_id)
			else:
				if weapon_ref:
					var award_xp = area.hit_xp * damage * xp_multiplier
					weapon_ref.award_xp(award_xp)
					LabelSpawner.spawn_label("+" + str(award_xp) + "xp",self.global_position)
					var player_id = weapon_ref.get_player_id()
					if player_id:
						Statistics.add_missiles_hit(player_id)
	explode()


func _on_body_entered(body):
	if exploded:
		return
	
	if body.has_method("get_hit"):
		body.get_hit(damage)
		if body.is_in_group("xp"):
			if body.hp <= 0:
				if weapon_ref:
					var award_xp = body.kill_xp * xp_multiplier
					weapon_ref.award_xp(award_xp)
					LabelSpawner.spawn_label("+" + str(award_xp) + "xp",self.global_position)
					var hud = get_tree().get_first_node_in_group("hud")
					hud.add_money(50)
					var player_id = weapon_ref.get_player_id()
					if player_id:
						Statistics.add_ships_destroyed(player_id)
			else:
				if weapon_ref:
					var award_xp = body.hit_xp * damage * xp_multiplier
					weapon_ref.award_xp(award_xp)
					LabelSpawner.spawn_label("+" + str(award_xp) + "xp",self.global_position)
					var player_id = weapon_ref.get_player_id()
					if player_id:
						Statistics.add_missiles_hit(player_id)
	explode()







func explode():
	var explosion_instance = explosion.instantiate()
	get_parent().add_child(explosion_instance)
	explosion_instance.global_position = self.global_position
	exploded = true
	queue_free()


func _on_homing_timer_timeout():
	homing = true
	$AudioStreamPlayer.play()
	$ThrustParticles.emitting = true
	$ThrustParticles/ThrustLight.show()
