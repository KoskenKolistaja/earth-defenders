extends AudioStreamPlayer





var song1 = preload("res://Assets/Music/Leaving Home.ogg")
var song2 = preload("res://Assets/Music/Martian Offense.ogg")
var song3 = preload("res://Assets/Music/Means To Survive.ogg")
var song4 = preload("res://Assets/Music/Uncharted.ogg")




var songs = [song1,song2,song3,song4]


func _ready():
	stream = songs[0]
	play()



func _on_finished():
	songs.push_back(songs[0])
	songs.remove_at(0)
	stream = songs[0]
	play()
