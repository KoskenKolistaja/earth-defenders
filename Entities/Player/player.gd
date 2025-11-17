extends Node3D

var player_id

var ship = null






func _physics_process(_delta):
	if Input.is_action_just_pressed("p%s_ui_accept" % player_id):
		if not ship:
			var hud = get_tree().get_first_node_in_group("hud")
			hud.spawn_ship_hud(player_id)
			ship = true






func ship_reserved():
	ship = null
