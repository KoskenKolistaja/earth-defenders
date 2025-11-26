extends Node

const SAVE_PATH_SP := "user://leaderboard_singleplayer.save"
const SAVE_PATH_MP := "user://leaderboard_multiplayer.save"

var scores_sp: Array = []
var scores_mp: Array = []


func _ready():
	load_scores()


# ---------------------------------------------------------
# Submit score
# mode_multiplayer = true → multiplayer
# mode_multiplayer = false → singleplayer
# ---------------------------------------------------------
func submit_score(score: int, run_name: String, mode_multiplayer: bool = false) -> void:
	var entry = {
		"name": run_name,
		"score": score,
		"time": Time.get_time_string_from_system()
	}

	var target_scores = scores_mp if mode_multiplayer else scores_sp

	target_scores.append(entry)

	# Sort highest first
	target_scores.sort_custom(func(a, b): return b["score"] < a["score"])

	# Keep top 10
	if target_scores.size() > 10:
		target_scores = target_scores.slice(0, 10)

	# Write back to correct list
	if mode_multiplayer:
		scores_mp = target_scores
	else:
		scores_sp = target_scores

	save_scores()


# ---------------------------------------------------------
# Save both leaderboards
# ---------------------------------------------------------
func save_scores() -> void:
	var file = FileAccess.open(SAVE_PATH_SP, FileAccess.WRITE)
	if file:
		file.store_var(scores_sp)
		file.close()

	file = FileAccess.open(SAVE_PATH_MP, FileAccess.WRITE)
	if file:
		file.store_var(scores_mp)
		file.close()


# ---------------------------------------------------------
# Load both leaderboards
# ---------------------------------------------------------
func load_scores() -> void:
	if FileAccess.file_exists(SAVE_PATH_SP):
		var f = FileAccess.open(SAVE_PATH_SP, FileAccess.READ)
		if f:
			scores_sp = f.get_var()
			f.close()
	else:
		scores_sp = []

	if FileAccess.file_exists(SAVE_PATH_MP):
		var f = FileAccess.open(SAVE_PATH_MP, FileAccess.READ)
		if f:
			scores_mp = f.get_var()
			f.close()
	else:
		scores_mp = []


# ---------------------------------------------------------
# Check if a score qualifies (SP or MP)
# ---------------------------------------------------------
func qualifies(score: int, mode_multiplayer: bool = false) -> bool:
	var target_scores = scores_mp if mode_multiplayer else scores_sp

	if target_scores.size() < 10:
		return true

	var lowest_top = target_scores.back()["score"]
	return score > lowest_top


# ---------------------------------------------------------
# Format leaderboard (SP or MP)
# ---------------------------------------------------------
func format_leaderboard(mode_multiplayer: bool = false) -> String:
	var target_scores = scores_mp if mode_multiplayer else scores_sp

	var output := ""
	var index := 1

	for entry in target_scores:
		output += "%d. %s - %d\n" % [
			index,
			entry.get("name", "Unnamed"),
			entry.get("score", 0)
		]
		index += 1

	return output.strip_edges()
