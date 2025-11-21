extends Panel

@export var stats_panel: PackedScene










func initiate_stats():
	for c in $StatsContainer.get_children():
		c.queue_free()
	
	for id in PlayerData.players:
		add_stats_panel(id)
	
	
	check_new_score()



func check_new_score():
	var hud = get_tree().get_first_node_in_group("hud")
	var score = hud.time
	
	$Label.text = str(score)
	
	if Leaderboard.qualifies(score):
		$HBoxContainer.hide()
		$StatsContainer.hide()
		$TextEdit.show()
	else:
		$Leaderboard.text = Leaderboard.format_leaderboard()



func add_stats_panel(player_id):
	var panel = stats_panel.instantiate()
	$StatsContainer.add_child(panel)
	var player_name      = PlayerData.player_names[player_id]

	var bullets_shot     = Statistics.bullets_fired[player_id]
	var missiles_shot    = Statistics.missiles_fired[player_id]

	var bullets_hit      = Statistics.bullets_hit[player_id]
	var missiles_hit     = Statistics.missiles_hit[player_id]

	var bullet_accuracy = 0.0
	if bullets_shot > 0:
		var ratio = float(bullets_hit) / float(bullets_shot)
		bullet_accuracy = snapped(ratio * 100, 0.1)

	var missile_accuracy = 0.0
	if missiles_shot > 0:
		var ratio = float(missiles_hit) / float(missiles_shot)
		missile_accuracy = snapped(ratio * 100, 0.1)

	var ships_destroyed  = Statistics.ships_destroyed[player_id]
	var rocks_destroyed  = Statistics.asteroids_destroyed[player_id]
	var ships_lost       = Statistics.ships_lost[player_id]

	print("Bullet accuracy: " + str(bullet_accuracy))
	print(missile_accuracy)

	# --- Panel setters ---
	panel.set_player_name(player_name)

	panel.set_bullets_hit(bullets_shot,bullets_hit)
	panel.set_bullet_accuracy(bullet_accuracy)

	panel.set_missiles_hit(missiles_shot,missiles_hit)
	panel.set_missile_accuracy(missile_accuracy)

	panel.set_ships_destroyed(ships_destroyed)
	panel.set_rocks_destroyed(rocks_destroyed)
	panel.set_ships_lost(ships_lost)


func _on_button_pressed():
	if not $TextEdit.text:
		$TextEdit/Label.text = "Insert name!"
		return
	
	if $TextEdit.text.length() > 10:
		$TextEdit/Label.text = "Name too long"
		return
	
	$TextEdit.hide()
	$HBoxContainer.show()
	$StatsContainer.show()
	var hud = get_tree().get_first_node_in_group("hud")
	var time = hud.time
	Leaderboard.submit_score(time,$TextEdit.text)
	$Leaderboard.text = Leaderboard.format_leaderboard()
