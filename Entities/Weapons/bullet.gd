extends Area3D



var direction : Vector3 = Vector3.UP
var speed : float = 0.3
var damage : int = 1


var weapon_ref

var xp_multiplier = 1


func  _ready():
	await get_tree().create_timer(1,false).timeout
	queue_free()


func _physics_process(delta):
	global_position += direction * speed
	look_at_from_position(self.global_position,self.global_position + direction * speed)







func _on_body_entered(body):
	if body.is_in_group("bullet_damaged"):
		body.get_hit(damage)
		if body.hp <= 0:
			if weapon_ref:
				weapon_ref.award_xp(1 * xp_multiplier)
				var hud = get_tree().get_first_node_in_group("hud")
				hud.add_money(10)
	queue_free()


func _on_area_entered(area):
	if area.is_in_group("bullet_damaged"):
		area.get_hit(damage)
		if area.hp <= 0:
			if weapon_ref:
				weapon_ref.award_xp(1 * xp_multiplier)
				var hud = get_tree().get_first_node_in_group("hud")
				hud.add_money(10)
	queue_free()
