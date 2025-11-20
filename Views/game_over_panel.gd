extends Panel

@export var stats_panel: PackedScene










func initiate_stats():
	for c in $StatsContainer.get_children():
		queue_free()
	
	for id in PlayerData.players:
		add_stats_panel(id)





func add_stats_panel(player_id):
	var panel = stats_panel.instantiate()
	$StatsContainer.add_child(panel)
	var player_name      = PlayerData.player_names[player_id]

	var bullets_shot     = Statistics.bullets_fired[player_id]
	var missiles_shot    = Statistics.missiles_fired[player_id]

	var bullets_hit      = Statistics.bullets_hit[player_id]
	var missiles_hit     = Statistics.missiles_hit[player_id]

	var bullet_accuracy  = snapped(bullets_hit / bullets_shot, 0.1) * 10 if bullets_shot > 0 else 0
	var missile_accuracy = snapped(missiles_hit / missiles_shot, 0.1) * 10 if missiles_shot > 0 else 0

	var ships_destroyed  = Statistics.ships_destroyed[player_id]
	var rocks_destroyed  = Statistics.asteroids_destroyed[player_id]
	var ships_lost       = Statistics.ships_lost[player_id]


	# --- Panel setters ---
	panel.set_player_name(player_name)

	panel.set_bullets_hit(bullets_shot,bullets_hit)
	panel.set_bullet_accuracy(bullet_accuracy)

	panel.set_missiles_hit(missiles_shot,missiles_hit)
	panel.set_missile_accuracy(missile_accuracy)

	panel.set_ships_destroyed(ships_destroyed)
	panel.set_rocks_destroyed(rocks_destroyed)
	panel.set_ships_lost(ships_lost)
