class_name EditingScene
extends Node2D

var open_session_data : SessionData

var SubliminalClass = preload("res://Scripts/SessionElement_Subliminal.gd")

func set_visibility(is_visible: bool):
	show()
	$CanvasLayer.visible = is_visible



func _on_add_subliminal_button_pressed() -> void:
	var new_element = SubliminalClass.new()
	new_element._start_time = 5.0
	new_element._end_time = 10.0
	new_element._messages.append("FromEditor")
	open_session_data.add_element(new_element)


func _on_back_to_menu_button_pressed() -> void:
	hide()
