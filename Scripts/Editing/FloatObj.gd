class_name FloatObj
extends RefCounted

var _value: float

signal on_value_changed(old_value: float, new_value: float)


func _init(in_value: float = 0.0):
	_value = in_value


func set_value(new_value: float) -> void:
	if _value != new_value:
		var old_value: float = _value
		_value = new_value
		on_value_changed.emit(old_value, new_value)


func get_value() -> float:
	return _value
