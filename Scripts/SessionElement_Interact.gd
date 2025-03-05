class_name SessionElement_Interact
extends SessionElement

var _button_sequence: Array[ButtonInteract]
var _next_awaited_button_index: int = 0
var _holding_awaited_button: bool = false
var _time_holding_awaited_button: float = 0.0
	

func _begin_element():
	super._begin_element()
	_next_awaited_button_index = 0


func _process_element(delta: float) -> bool:
	var still_running = super._process_element(delta)
	if !still_running:
		return false
	if _next_awaited_button_index >= _button_sequence.size():
		_end_element()
		return false
	if _holding_awaited_button:
		_time_holding_awaited_button += delta
		if _time_holding_awaited_button > get_awaited_interact().get_hold_time():
			_advance_awaited_button()
		if _next_awaited_button_index >= _button_sequence.size():
			_end_element()
			return false
	return true


func get_awaited_interact() -> ButtonInteract:
	if _next_awaited_button_index < _button_sequence.size():
		return _button_sequence[_next_awaited_button_index]
	else:
		return null


func add_button_interact() -> void:
	var new_button_interact = ButtonInteract.new()
	_button_sequence.append(new_button_interact)


func remove_button_interact(to_remove: ButtonInteract) -> void:
	_button_sequence.erase(to_remove)


func get_button_sequence() -> Array[ButtonInteract]:
	return _button_sequence
	

func get_default_display_name() -> String:
	return "Interact"


func _input(event: InputEvent) -> void:
	if !(event is InputEventKey) || !is_element_active():
		return
	var key_event: InputEventKey = event
	
	var awaited_interact: ButtonInteract = get_awaited_interact()
	if awaited_interact == null:
		return
		
	if key_event.keycode == awaited_interact.get_bound_key():
		if key_event.pressed:
			if awaited_interact.get_hold_time() <= 0.0:
				_advance_awaited_button()
			else: if !_holding_awaited_button:
				_holding_awaited_button = true
				_time_holding_awaited_button = 0.0
		else:
			_holding_awaited_button = false
			

func _advance_awaited_button() -> void:
	_next_awaited_button_index = _next_awaited_button_index + 1
	_holding_awaited_button = false
