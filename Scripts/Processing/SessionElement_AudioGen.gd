class_name SessionElement_AudioGen
extends SessionElement

var left_frequency: FloatObj = FloatObj.new(440.0)
var right_frequency: FloatObj = FloatObj.new(440.0)
var amplitude: FloatObj = FloatObj.new(0.2) # Volume, from 0.0 to 1.0
var id: int

static func get_type_static() -> String:
	return "AUDIOGEN"

func _init() -> void:
	super._init()
	_end_time.set_value(10.0)

func process_element(delta: float):
	super.process_element(delta)

func get_default_display_name() -> String:
	return "AudioGen"

func encode_to_json() -> Dictionary:
	var out : Dictionary = super.encode_to_json()
	out.get_or_add("left_frequency", left_frequency.get_value())
	out.get_or_add("right_frequency", right_frequency.get_value())
	out.get_or_add("amplitude", amplitude.get_value())
	return out

func decode_from_json(entry : Dictionary) -> void:
	super.decode_from_json(entry)
	left_frequency.set_value(entry["left_frequency"])
	right_frequency.set_value(entry["right_frequency"])
	amplitude.set_value(entry["amplitude"])

func get_type() -> String:
	return get_type_static()

func can_run() -> bool:
	return true

func get_left_frequency_ref():
	return left_frequency

func get_right_frequency_ref():
	return right_frequency

func get_amplitude_ref():
	return amplitude
