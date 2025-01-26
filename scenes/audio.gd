extends AudioStreamPlayer

const music = preload("res://audio/El Fernezaso 2.mp3")

func _play_music(music: AudioStream, volume = -10.0)->void:
	if stream == music:
		return
	
	stream = music
	volume_db = volume
	play()

func play_music()->void:
	_play_music(music)
	
