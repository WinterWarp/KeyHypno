extends Node2D
var _canvas: CanvasLayer
var HSControl: Control
var HSSessionData: SessionData
var active_session_data: SessionData
var audio_player: AudioStreamPlayer


func _ready():
	_canvas = $SessionCanvas
	audio_player = $Control/ASPlayer2D
	HSControl = $Control
	visibility_changed.connect(_handle_visibility_changed)
		
		
func _handle_visibility_changed():
	_canvas.visible = visible


func begin_session():
	if active_session_data == null:
		return
	_canvas.session_data = active_session_data
	active_session_data.begin_session()


func _on_main_menu_button_pressed() -> void:
	if active_session_data != null:
		active_session_data._paused = true
	if audio_player.playing:
		audio_player.stop()
	hide()
