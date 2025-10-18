extends Node



var players = []

var player_colors = {}
var player_icons = {}


func add_player(exported_id):
	if not players.has(exported_id):
		players.append(exported_id)
