extends Button

func _button_pressed():
	var Error = get_tree().change_scene_to_file("res://Scenes/HypnoScene.tscn")
	if Error:
		print("Error %d when changing scene." % Error)
	
func _ready():
	pressed.connect(self._button_pressed)
