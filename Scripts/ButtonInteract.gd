class_name ButtonInteract
extends RefCounted

var _bound_key : Key
#var _is_hold : bool = false
var _hold_time : FloatObj = FloatObj.new(0.0)

func _ready() -> void:
	pass

func set_bound_key(in_bound_key: Key) -> void:
	_bound_key = in_bound_key

func get_bound_key() -> Key:
	return _bound_key
	
func get_hold_time_ref() -> FloatObj:
	return _hold_time
	
func get_hold_time() -> float:
	return _hold_time.get_value()
