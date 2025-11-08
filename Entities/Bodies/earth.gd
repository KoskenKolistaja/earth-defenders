extends StaticBody3D


var hp = 100
var shield = 0

var dead = false

@export var nozzle : PackedScene

@onready var shield_mat: ShaderMaterial = $ShieldMesh.get_active_material(0)

var shield_disabled = true


func _physics_process(delta):
	
	$Pivot.rotation_degrees.z += 0.1
	
	if dead:
		move_fractures()

func _ready():
	show_hp()
	show_shield()
	disable_shield()







func show_hp():
	$HpBar.show_hp(hp)

func show_shield():
	$ShieldBar.show_shield(hp + shield)


func move_fractures():
	var fractures = $FracturedEarth.get_children()
	
	for fracture in fractures:
		var movement_vector = fracture.global_position.normalized()
		fracture.global_position += movement_vector * 0.02

func setup_fractures():
	var fractures = $FracturedEarth.get_children()
	
	for fracture in fractures:
		var nozzle_instance = nozzle.instantiate()
		fracture.add_child(nozzle_instance)



func disable_shield(duration: float = 1.0):
	if shield_mat:
		create_tween().tween_property(
			shield_mat, "shader_parameter/overall_opacity", 0.0, duration
		).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	print("Yes!!")

# Animate opacity to 0.6 (activate)
func activate_shield(duration: float = 1.0):
	if shield_mat:
		create_tween().tween_property(
			shield_mat, "shader_parameter/overall_opacity", 0.6, duration
		).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func get_hit(damage : int = 5):
	
	if shield > 0:
		shield -= damage
		
		if shield < 1:
			hp += shield
			shield = 0
			disable_shield()
			shield_disabled = true
	else:
		hp -= damage
		
		if not shield_disabled:
			disable_shield()
	
	if hp <= 0 and not dead:
		die()
	
	print(shield)
	
	show_hp()
	show_shield()




func heal(amount : int = 1):
	hp += amount
	
	if not hp == 100:
		show_hp()
	hp = clamp(hp,-100,100)


func add_shield(amount : int = 1):
	
	if shield_disabled:
		activate_shield()
		shield_disabled = false
	
	
	shield += amount
	if not shield == 20:
		show_shield()
	shield = clamp(shield,-100,20)

func die():
	var death_song = preload("res://Assets/Music/It's over.ogg")
	$HpBar.active = false
	$HpBar.hide()
	$DeathArea.active = true
	dead = true
	$MeshInstance3D.hide()
	$CollisionShape3D.disabled = true
	$FracturedEarth.show()
	$GPUParticles3D.emitting = true
	$AudioStreamPlayer.play()
	MetaData.game_over = true
	var music : AudioStreamPlayer = get_tree().get_first_node_in_group("music")
	await get_tree().create_timer(0.5,false).timeout
	music.stream = death_song
	music.play()
	await get_tree().create_timer(13.0,false).timeout
	var hud = get_tree().get_first_node_in_group("hud")
	hud.game_over()
