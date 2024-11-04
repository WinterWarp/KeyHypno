extends Node2D
var HSCanvasLayer: CanvasLayer
var HSControl: Control

func _ready():
	HSCanvasLayer = $CanvasLayer
	HSControl = $Control

func set_visibility(is_visible: bool):
	HSCanvasLayer.visible = is_visible
	HSControl.visible = is_visible
