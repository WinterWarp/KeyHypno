extends AudioStreamPlayer

@export var path = ""


func play_path(session_data: ZIPReader, new_path: String):
	print("playing: " + new_path)
	get_node(".").stop()
	path = new_path
	var hypno_scene_audio_player = get_node(".")
	if path.is_empty():
		return
	match path.right(3).to_lower():
		"ogg":
			if session_data != null:
				hypno_scene_audio_player.stream = AudioStreamOggVorbis.load_from_buffer(session_data.read_file(new_path))
			else:
				var file = FileAccess.open(path, FileAccess.READ)
				hypno_scene_audio_player.stream = AudioStreamOggVorbis.load_from_buffer(file.get_buffer(file.get_length()))
		"mp3":
			var mp3 = AudioStreamMP3.new()
			if session_data != null:
				mp3.data = session_data.read_file(new_path)
			else:
				var file = FileAccess.open(path, FileAccess.READ)
				mp3.data = file.get_buffer(file.get_length())

			hypno_scene_audio_player.stream = mp3
		_:
			print("unexpected file type")
	hypno_scene_audio_player.play()
