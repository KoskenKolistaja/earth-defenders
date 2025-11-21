extends NinePatchRect


func set_player_name(exported_name : String):
	$PlayerName.text = exported_name




func set_bullets_hit(total_shots,hit):
	$VBoxContainer/BulletsHit/Label2.text =  str(hit) + "/" + str(total_shots)

func set_missiles_hit(total_shots,hit):
	$VBoxContainer/MissilesHit/Label2.text =  str(hit) + "/" + str(total_shots)

func set_bullet_accuracy(amount):
	$VBoxContainer/BulletAccuracy/Label2.text = str(amount) + "%"

func set_missile_accuracy(amount):
	$VBoxContainer/MissileAccuracy/Label2.text = str(amount) + "%"

func set_ships_destroyed(amount):
	$VBoxContainer/ShipsDestroyed/Label2.text = str(amount)

func set_rocks_destroyed(amount):
	$VBoxContainer/RocksDestroyed/Label2.text = str(amount)

func set_ships_lost(amount):
	$VBoxContainer/ShipsLost/Label2.text = str(amount)
