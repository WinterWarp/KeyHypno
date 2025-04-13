class_name SessionData
extends Node

var _elements: Array[SessionElement]
var _paused: bool = true
var _global_time: float = 0.0


func _ready() -> void:
	pass


func begin_session():
	_global_time = 0.0
	_paused = false


func _process(delta: float) -> void:
	if _paused:
		return
	var old_global_time: float = _global_time
	var time_advancing: bool = _should_time_advance()
	if time_advancing:
		_global_time += delta
	else:
		delta = 0.0
	var has_incomplete_element: bool = false
	for element: SessionElement in _elements:
		if element.is_element_active():
			if time_advancing || element is SessionElement_Interact:
				element._process_element(delta)
		else:
			if (
				old_global_time <= element.get_start_time()
				and _global_time > element.get_start_time()
			):
				element._begin_element()
				element._process_element(_global_time - element.get_start_time())
		has_incomplete_element = (
			has_incomplete_element
			|| element.is_element_active()
			|| _global_time < element.get_start_time()
		)
	if !has_incomplete_element:
		_paused = true


func add_element(new_element: SessionElement):
	_elements.append(new_element)


func delete_element(element: SessionElement):
	var index: int = _elements.find(element)
	_elements.remove_at(index)


func add_element_of_class(new_element_class: Resource) -> SessionElement:
	var new_element = new_element_class.new()
	add_element(new_element)
	return new_element


func reset_and_clear():
	_paused = true
	_global_time = 0.0
	_elements.clear()


func get_active_elements():
	return _elements.filter(func(element: SessionElement): return element.is_element_active())
	
	
func is_element_name_in_use(in_name: String, element_to_ignore: SessionElement) -> bool:
	for element in _elements:
		if element != element_to_ignore and element.get_display_name() == in_name:
			return true
	return false


func get_element_by_display_name(in_name: String) -> SessionElement:
	for element in _elements:
		if element.get_display_name() == in_name:
			return element
	return null
	
	
func assign_unique_default_display_name_to_element(element: SessionElement) -> void:
	element._display_name.set_value(_update_display_name_until_unique(element, element.get_default_display_name()))
	
	
func update_display_name_of_element_to_be_unique(element: SessionElement) -> void:
	element._display_name.set_value(_update_display_name_until_unique(element, element.get_display_name()))


func _update_display_name_until_unique(element: SessionElement, preferred_name: String) -> String:
	var suffix: int = 0
	while true:
		var chosen_name: String = preferred_name
		if suffix > 0:
			chosen_name += str(suffix)
		suffix += 1
		if !is_element_name_in_use(chosen_name, element):
			return chosen_name
	return ""


func _should_time_advance() -> bool:
	for element: SessionElement in _elements:
		if element.is_element_active() && element is SessionElement_Interact:
			return false
	return true
	
	
func debug_print() -> void:
	for element in _elements:
		element.debug_print()


func encode_to_json() -> String:
	var sav : Array[Dictionary] = []
	for element in _elements:
		sav.append(element.encode_to_json())
	return JSON.stringify(sav)


func json_destringify(data: String) -> Array:
	# parse data
	var json = JSON.new()
	var error = json.parse(data)
	# verify data
	if error == OK:
		var data_received : Array = json.data
		if typeof(data_received) == TYPE_ARRAY:
			data_received.sort_custom(func(a, b): return a["start_time"] < b["start_time"])  # sort by time so we can assume events are in order
			return data_received
		else:
			print("data is of invalid type")
			return []
	else:
		print(
			"JSON Parse Error: ",
			json.get_error_message(),
			" in ",
			data,
			" at line ",
			json.get_error_line()
		)
		return []

func decode_from_json(data: String) -> void:
	var sav: Array = json_destringify(data)
	for entry : Dictionary in sav:
		var element: SessionElement
		if entry["type"] == SessionElement_Subliminal.get_type_static():
			element = add_element_of_class(SessionElement_Subliminal)
		else: if entry["type"] == SessionElement_Audio.get_type_static():
			element = add_element_of_class(SessionElement_Audio)
		else: if entry["type"] == SessionElement_Interact.get_type_static():
			element = add_element_of_class(SessionElement_Interact)
		else:
			print("invalid event type" + entry.type)
			return
		element.decode_from_json(entry)
		if !entry.has("display_name"):
			assign_unique_default_display_name_to_element(element)


func load_from_file(path: String) -> void:
	reset_and_clear()
	var reader: ZIPReader = ZIPReader.new()
	reader.open(path)
	var files = reader.get_files()
	files.sort()
	print(files)
	var data: String = reader.read_file("Elements.txt").get_string_from_utf8()
	decode_from_json(data)
