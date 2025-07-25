class_name SessionElement
extends RefCounted

var _display_name: StringObj = StringObj.new("")
var _start_time: FloatObj = FloatObj.new(0.0)
var _end_time: FloatObj = FloatObj.new(-1.0)
var _local_time: float = 0.0
var _is_active: bool = false

signal on_display_name_changed(old_name: String, new_name: String)


func _init() -> void:
	_display_name.on_value_changed.connect(_handle_display_name_value_changed)
	

func begin_element():
	_is_active = true
	_local_time = 0.0


func process_element(delta: float) -> void:
	_local_time += delta
	if _end_time.get_value() >= 0.0 && _start_time.get_value() + _local_time > _end_time.get_value():
		_end_element()


func reset_element_execution():
	_is_active = false
	_local_time = 0.0


func get_display_name() -> String:
	return _display_name.get_value()


func get_display_name_ref() -> StringObj:
	return _display_name


func get_start_time() -> float:
	return _start_time.get_value()
	

func get_start_time_ref() -> FloatObj:
	return _start_time


func get_end_time() -> float:
	return _end_time.get_value()
	

func get_end_time_ref() -> FloatObj:
	return _end_time


func get_local_time():
	return _local_time


func is_element_active():
	return _is_active
	

func get_default_display_name() -> String:
	return "Element"


func _end_element():
	_is_active = false
	
	
func _handle_display_name_value_changed(old_value: String, new_value: String) -> void:
	on_display_name_changed.emit(old_value, new_value)
	
	
func encode_to_json() -> Dictionary:
	return {
		"type": get_type(),
		"display_name": get_display_name(),
		"start_time": get_start_time(),
		"end_time": get_end_time()
	}
	
	
func decode_from_json(entry : Dictionary) -> void:
		if entry.has("display_name"):
			_display_name.set_value(entry["display_name"])
		_start_time.set_value(entry["start_time"])
		_end_time.set_value(entry["end_time"])
	

func get_type() -> String:
	return ""


func save_files_to_new_manifest(session_data: SessionData) -> void:
	pass


func populate_file_data_from_manifest(session_data: SessionData) -> void:
	pass


func can_run() -> bool:
	return true
	
	
func debug_print() -> void:
	print("_display_name: " + _display_name.get_value())
	print("_start_time: " + str(_start_time.get_value()))
	print("_end_time: " + str(_end_time.get_value()))
	print("_local_time: " + str(_local_time))
	print("_is_active: " + str(_is_active))
	
func _input(event: InputEvent) -> void:
	pass
