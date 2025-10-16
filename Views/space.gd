extends Node3D

@export var player_scene : PackedScene




func _ready():
	for id in PlayerData.players:
		var player_instance = player_scene.instantiate()
		$Objects.add_child(player_instance)
		player_instance.player_id = id + 1
