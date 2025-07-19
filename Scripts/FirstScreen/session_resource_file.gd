class_name SessionResourceFile
extends RefCounted

var _file_data: PackedByteArray
var _file_local_path: String
var _is_local: bool

func _init(in_filepath: String):
	_file_local_path = in_filepath
	_is_local = true


func set_loaded_file_data(in_file_data: PackedByteArray) -> void:
	_file_data = in_file_data
	_is_local = false


func get_file_data() -> PackedByteArray:
	if _file_data.is_empty():
		var file: FileAccess = FileAccess.open(_file_local_path, FileAccess.READ)
		_file_data = file.get_buffer(file.get_length())
	return _file_data


func encode_to_json() -> Dictionary:
	return {
		"file_local_path": _file_local_path,
	}


func decode_from_json(meta_data: Dictionary) -> void:
	_file_local_path = meta_data["file_local_path"]
	_is_local = false


func get_local_path() -> String:
	return _file_local_path
