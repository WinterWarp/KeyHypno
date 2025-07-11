class_name StringObj
extends RefCounted

var _value: String

signal on_value_changed(old_value: String, new_value: String)


func _init(in_value: String = ""):
	_value = in_value


func set_value(new_value: String) -> void:
	if _value != new_value:
		var old_value: String = _value
		_value = new_value
		on_value_changed.emit(old_value, new_value)


func get_value() -> String:
	return _value
