extends Area3D




var direction : Vector3 = Vector3.UP
var speed : float = 0.5
var damage : int = 2

var penetration = false

var weapon_ref

var fly_time = 1.2

var xp_multiplier = 1

func  _ready():
	await get_tree().create_timer(fly_time,false).timeout
	queue_free()


func _physics_process(delta):
	global_position += direction * speed
	look_at_from_position(self.global_position,self.global_position + direction * speed)




func _on_body_entered(body):
	if body.is_in_group("bullet_damaged"):
		body.get_hit(damage)
		
		if body.is_in_group("xp"):
			if body.hp <= 0:
				if weapon_ref:
					var award_xp = body.kill_xp * xp_multiplier
					weapon_ref.award_xp(award_xp)
					LabelSpawner.spawn_label("+" + str(award_xp) + "xp",self.global_position)
					var hud = get_tree().get_first_node_in_group("hud")
					hud.add_money(50)
			else:
				if weapon_ref:
					var award_xp = body.hit_xp * damage * xp_multiplier
					weapon_ref.award_xp(award_xp)
					LabelSpawner.spawn_label("+" + str(award_xp) + "xp",self.global_position)
	if not penetration:
		queue_free()
	
	if body.is_in_group("non_penetratable"):
		queue_free()








func _on_area_entered(area):
	if area.is_in_group("bullet_damaged"):
		area.get_hit(damage)
		
		if area.is_in_group("xp"):
			if area.hp <= 0:
				if weapon_ref:
					var award_xp = area.kill_xp * xp_multiplier
					weapon_ref.award_xp(award_xp)
					LabelSpawner.spawn_label("+" + str(award_xp) + "xp",self.global_position)
					var hud = get_tree().get_first_node_in_group("hud")
					hud.add_money(50)
			else:
				if weapon_ref:
					var award_xp = area.hit_xp * damage * xp_multiplier
					weapon_ref.award_xp(award_xp)
					LabelSpawner.spawn_label("+" + str(award_xp) + "xp",self.global_position)
	if not penetration:
		queue_free()
	if area.is_in_group("non_penetratable"):
		queue_free()
