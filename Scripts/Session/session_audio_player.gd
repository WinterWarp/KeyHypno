extends AudioStreamPlayer

var _currently_playing_file_data: PackedByteArray


func play_file_data(file_data: PackedByteArray, file_ext: String) -> void:
	stop_and_clear()
	match file_ext:
		"ogg":
			stream = AudioStreamOggVorbis.load_from_buffer(file_data)
		"mp3":
			var mp3 := AudioStreamMP3.new()
			mp3.data = file_data
			stream = mp3
		_:
			print("unexpected file type '" + file_ext + "'")
	play()
	_currently_playing_file_data = file_data


func is_playing_data(file_data: PackedByteArray) -> bool:
	return playing and _currently_playing_file_data == file_data


func stop_and_clear() -> void:
	stop()
	stream = null
