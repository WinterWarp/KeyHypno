class_name SessionElement_Audio
extends SessionElement

var path: String
var id: int
	

static func get_type_static() -> String:
	return "AUDIO"


func _init() -> void:
	super._init()
	_end_time.set_value(1.0)


func _process_element(delta: float):
	var StillRunning = super._process_element(delta)
	if !StillRunning:
		return false
	return true
	

func get_default_display_name() -> String:
	return "Audio"


func encode_to_json() -> Dictionary:
	var out : Dictionary = super.encode_to_json()
	out.get_or_add("path", path)
	return out
	
	
func decode_from_json(entry : Dictionary) -> void:
	super.decode_from_json(entry)
	path = entry["path"]
	

func get_type() -> String:
	return get_type_static()
