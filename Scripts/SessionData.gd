extends Node

var _elements : Array[SessionElement]
var SubliminalClass = preload("res://Scripts/SessionElement_Subliminal.gd")
var _paused : bool = true
var _global_time : float = 0.0

func _ready() -> void:
	_elements.append(SubliminalClass.new())
	var TestSub = _elements[0]
	TestSub._end_time = 3.0
	_paused = false

func _process(delta: float) -> void:
	if _paused:
		return
	var old_global_time : float = _global_time
	_global_time += delta
	var has_incomplete_element : bool = false
	for element in _elements:
		if element.is_element_active():
			element._process_element(delta)
		else:
			if old_global_time <= element.get_start_time() and _global_time > element.get_start_time():
				element._begin_element()
				element._process_element(_global_time - element.get_start_time())
		has_incomplete_element = has_incomplete_element || element.is_element_active || _global_time < element.get_start_time()
	# TODO: end session if has_incomplete_element is false.
