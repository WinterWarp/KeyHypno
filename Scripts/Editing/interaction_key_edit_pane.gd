extends Control

var _button_interact_instance: ButtonInteract
var _waiting_for_key_bind: bool = false

@onready
var _key_label: Label = $KeyContainer/KeyLabel
@onready
var _hold_duration_line_edit: FloatPropLineEdit = $HoldContainer/HoldDurationLineEdit

signal on_delete(pane_being_deleted: Control)


func _on_bind_key_button_pressed() -> void:
	_waiting_for_key_bind = true


func set_button_interact_instance(in_button_interact_instance: ButtonInteract) -> void:
	_button_interact_instance = in_button_interact_instance
	if _button_interact_instance != null:
		_update_bound_key_label()
		_hold_duration_line_edit.set_property_reference(_button_interact_instance.get_hold_time_ref())


func get_button_interact_instance() -> ButtonInteract:
	return _button_interact_instance
	

func _input(event: InputEvent) -> void:
	if !_waiting_for_key_bind:
		return
	
	if !(event is InputEventKey):
		return
		
	var key_event: InputEventKey = event
	if key_event.pressed:
		_button_interact_instance.set_bound_key(key_event.keycode)
	_waiting_for_key_bind = false
	_update_bound_key_label()
	
	
func _update_bound_key_label() -> void:
	_key_label.text = "Key: " + OS.get_keycode_string(_button_interact_instance.get_bound_key())


func _on_delete_button_pressed() -> void:
	on_delete.emit(self)
