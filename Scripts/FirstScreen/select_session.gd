extends FileDialog

signal on_session_file_selected(path: String)


func _ready() -> void:
	pass
	

func _handle_file_selected(path: String):
	var extension: String = path.get_extension()
	match extension:
		"hypsav":
			on_session_file_selected.emit(path)
		_:
			# TODO: show a user-facing error message
			print("Expected hypsav file, cannot process '", path.get_file(), "'")
	

func _handle_load_file_pressed():
	popup()
