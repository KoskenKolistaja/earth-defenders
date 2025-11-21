extends Node

const SAVE_PATH := "user://leaderboard.save"

# Each entry will look like:
# { "name": "Run 1", "score": 123, "time": 1713465923 }
var scores: Array = []


func _ready():
	load_scores()


# ---------------------------------------------------------
# PUBLIC: Submit score + run name
# ---------------------------------------------------------
func submit_score(score: int, run_name: String) -> void:
	var entry = {
		"name": run_name,
		"score": score,
		"time": Time.get_time_string_from_system() # optional
	}

	scores.append(entry)

	# Sort by score (highest first)
	scores.sort_custom(func(a, b): return b["score"] < a["score"])

	# Keep only top 10
	if scores.size() > 10:
		scores = scores.slice(0, 10)

	save_scores()


# ---------------------------------------------------------
# Save to disk
# ---------------------------------------------------------
func save_scores() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_var(scores)
		file.close()


# ---------------------------------------------------------
# Load from disk
# ---------------------------------------------------------
func load_scores() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		scores = []
		return

	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		scores = file.get_var()
		file.close()


func qualifies(score: int) -> bool:
	# If fewer than 10 scores, it always qualifies
	if scores.size() < 10:
		return true

	# Scores are sorted from best → worst
	# So the last one is the worst top score
	var lowest_top_score = scores.back()["score"]

	return score > lowest_top_score

func format_leaderboard() -> String:
	var output := ""
	var index := 1

	for entry in scores:
		output += "%d. %s - %d\n" % [
			index,
			entry.get("name", "Unnamed"),
			entry.get("score", 0)
		]
		index += 1

	return output.strip_edges() # remove last newline
