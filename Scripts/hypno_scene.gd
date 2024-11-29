extends Node2D
var HSCanvasLayer: CanvasLayer
var HSControl: Control
var HSSessionData: SessionData
var active_session_data: SessionData

func _ready():
	HSCanvasLayer = $SessionCanvas
	HSControl = $Control
	HSSessionData = $Session

func set_visibility(is_visible: bool):
	HSCanvasLayer.visible = is_visible
	HSControl.visible = is_visible
