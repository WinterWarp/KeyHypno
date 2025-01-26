class_name FloatPropLineEdit
extends LineEdit

var _property_reference: FloatObj


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	focus_exited.connect(_handle_focus_exited)
	text_submitted.connect(_handle_text_submitted)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func set_property_reference(ref: FloatObj) -> void:
	_property_reference = ref
	text = str(_property_reference.get_value())
	

func _handle_focus_exited() -> void:
	_update_from_text()
	
	
func _handle_text_submitted(_new_text: String) -> void:
	_update_from_text()
	
	
func _update_from_text() -> void:
	_property_reference.set_value(text.to_float())
	# Update the text according to the value we parsed from the entered string.
	# So if the entered text wasn't a valid float, we "snap back" to having a float in the text box.
	text = str(_property_reference.get_value())
