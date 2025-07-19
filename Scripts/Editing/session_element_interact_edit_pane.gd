extends Control

var InteractionKeyEditPaneScene = preload("res://Scenes/InteractionKeyEditPane.tscn")

@onready
var _interaction_key_container: VBoxContainer = $InteractionKeyContainer 

var _editing_element: SessionElement_Interact


func set_editing_element(in_editing_element: SessionElement_Interact) -> void:
	_editing_element = in_editing_element
	populate_pane()


func populate_pane() -> void:
	for child in _interaction_key_container.get_children():
		_interaction_key_container.remove_child(child)
	if _editing_element == null:
		return
		
	_interaction_key_container.add_child(HSeparator.new())
	for interact: ButtonInteract in _editing_element.get_button_sequence():
		_add_interaction_key_edit_pane(interact)
	
	var new_button_interact_button: Button = Button.new()
	new_button_interact_button.text = "Add Button Interact"
	new_button_interact_button.pressed.connect(_handle_new_button_interact_button_pressed)
	add_child(new_button_interact_button) 
		
		
func _handle_new_button_interact_button_pressed():
	_editing_element.add_button_interact()
	_add_interaction_key_edit_pane(_editing_element.get_button_sequence().back())
	
	
func _add_interaction_key_edit_pane(interact: ButtonInteract) -> void:
	var key_edit_pane = InteractionKeyEditPaneScene.instantiate()
	_interaction_key_container.add_child(key_edit_pane)
	_interaction_key_container.add_child(HSeparator.new())
	key_edit_pane.set_button_interact_instance(interact)
	key_edit_pane.on_delete.connect(_handle_interaction_key_delete)
	
	
func _handle_interaction_key_delete(pane_being_deleted: Control) -> void:
	_editing_element.remove_button_interact(pane_being_deleted.get_button_interact_instance())
	var index: int = _interaction_key_container.get_children().find(pane_being_deleted)
	_interaction_key_container.remove_child(pane_being_deleted)
	_interaction_key_container.remove_child(_interaction_key_container.get_child(index)) # also remove the HSpacer
	
