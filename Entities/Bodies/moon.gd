extends StaticBody3D

var hp = 100







func get_hit(damage : int = 1):
	hp -= damage
