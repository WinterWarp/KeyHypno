class_name SessionElement_Subliminal
extends SessionElement

var _messages: Array[String]
var _time_per_message: FloatObj = FloatObj.new(1.0)
var _time_since_message_change: float
var _message_index: int
	

static func get_type_static() -> String:
	return "SUBLIMINAL"


func _init() -> void:
	super._init()
	_end_time.set_value(1.0)
	
func _begin_element():
	super._begin_element()
	_message_index = -1
	_randomise_message_index()
	_time_since_message_change = 0.0


func _process_element(delta: float):
	var StillRunning = super._process_element(delta)
	if !StillRunning:
		return false
	_time_since_message_change += delta
	if _time_since_message_change > _time_per_message.get_value():
		_time_since_message_change -= _time_per_message.get_value()
		_randomise_message_index()
	return true


func _end_element():
	super._end_element()


func _randomise_message_index():
	if _messages.is_empty():
		return
	if _messages.size() == 1:
		_message_index = 0
		return

	if _message_index == -1:
		# No message chosen yet, choose any
		_message_index = randi_range(0, _messages.size() - 1)
	else:
		# Don't choose the same message that's currently chosen
		var new_message_index = randi_range(0, _messages.size() - 2)
		if new_message_index >= _message_index:
			new_message_index = new_message_index + 1
		_message_index = new_message_index


func get_current_message():
	if _message_index == -1:
		return ""
	else:
		return _messages[_message_index]


func get_time_per_message():
	return _time_per_message.get_value()


func get_time_per_message_ref():
	return _time_per_message


#func save_file(path):
#	var file = FileAccess.open(path, FileAccess.WRITE)
#	for message in _messages:
#		file.store_string(message + "\n")


#func load_file(path):
#	var file = FileAccess.open(path, FileAccess.READ)
#	var content = file.get_as_text()
#	print(content)
#	var content_packed_array = content.split("\n")
#	print("packed array: ", content_packed_array.size())
#	for packed_string in content_packed_array:
#		_messages.append(packed_string)
	

func get_default_display_name() -> String:
	return "Subliminal"
	
	
func encode_to_json() -> Dictionary:
	var out : Dictionary = super.encode_to_json()
	out.get_or_add("time_per_message", get_time_per_message())
	out.get_or_add("messages", _messages)
	return out
	
	
func decode_from_json(entry : Dictionary) -> void:
	super.decode_from_json(entry)
	_time_per_message.set_value(entry["time_per_message"])
	for line in entry["messages"]:
		_messages.append(line)
	

func get_type() -> String:
	return get_type_static()


func debug_print() -> void:
	super.debug_print()
	print("_messages: ")
	for message in _messages:
		print("    " + message)
	print("_time_per_message: " + str(_time_per_message))
	print("_time_since_message_change: " + str(_time_since_message_change))
	print("_message_index: " + str(_message_index))
	
