extends Node



var players = []




func add_player(exported_id):
	if not players.has(exported_id):
		players.append(exported_id)
