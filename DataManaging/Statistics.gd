extends Node

# --- STAT DICTIONARIES ---
var bullets_fired := {}
var missiles_fired := {}
var bullets_hit := {}
var missiles_hit := {}

var ships_destroyed := {}
var asteroids_destroyed := {}

var ships_lost := {}


func _ready():
	initialize_stats()


func _physics_process(delta):
	print(bullets_hit)


# --- INITIALIZATION ---

# Clears all stats (optional use)
func initialize_stats():
	bullets_fired.clear()
	missiles_fired.clear()
	bullets_hit.clear()
	missiles_hit.clear()
	ships_destroyed.clear()
	ships_lost.clear()

# Sets default values for a new player
func init_player(player_id: int):
	bullets_fired[player_id] = 0
	missiles_fired[player_id] = 0
	bullets_hit[player_id] = 0
	missiles_hit[player_id] = 0
	ships_destroyed[player_id] = 0
	ships_lost[player_id] = 0
	asteroids_destroyed[player_id] = 0

func initialize_from_playerdata():
	for player_id in PlayerData.players:
		init_player(player_id)


# --- INTERNAL HELPER ---
# Generic increment function
func _add(stat_dict: Dictionary, player_id: int, amount: int = 1):
	stat_dict[player_id] = stat_dict.get(player_id, 0) + amount



# --- ADD FUNCTIONS (Public API) ---

# Bullets
func add_bullets_fired(player_id: int, amount: int = 1):
	_add(bullets_fired, player_id, amount)

func add_bullets_hit(player_id: int, amount: int = 1):
	_add(bullets_hit, player_id, amount)


# Missiles
func add_missiles_fired(player_id: int, amount: int = 1):
	_add(missiles_fired, player_id, amount)

func add_missiles_hit(player_id: int, amount: int = 1):
	_add(missiles_hit, player_id, amount)


# Ships
func add_ships_destroyed(player_id: int, amount: int = 1):
	_add(ships_destroyed, player_id, amount)

func add_ships_lost(player_id: int, amount: int = 1):
	_add(ships_lost, player_id, amount)

func add_asteroids_destroyed(player_id: int, amount: int = 1):
	_add(asteroids_destroyed, player_id, amount)
