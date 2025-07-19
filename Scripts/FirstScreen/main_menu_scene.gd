extends Node2D

var _canvas: CanvasLayer
var _session_selected_label: Label
var _scene_container: Node2D
var session_data : SessionData

var _hypno_scene_res: Resource = preload("res://Scenes/HypnoScene.tscn")
var _hypno_scene: Node2D

var _editing_scene_res: Resource = preload("res://Scenes/EditingScene.tscn")
var _editing_scene: EditingScene


func _ready():
	_canvas = $MainMenuUI
	_session_selected_label = $MainMenuUI/SessionSelectedLabel
	_scene_container = $SceneContainer
	session_data = SessionData.new()
	add_child(session_data)


func start_hypno():
	_canvas.visible = false
	if _hypno_scene == null:
		_hypno_scene = _hypno_scene_res.instantiate()
		_scene_container.add_child(_hypno_scene)
		_hypno_scene.hidden.connect(_on_hypno_scene_hidden)
	_hypno_scene.show()
	_hypno_scene.active_session_data = session_data
	_hypno_scene.begin_session()


func start_editing():
	_canvas.visible = false
	if _editing_scene == null:
		_editing_scene = _editing_scene_res.instantiate()
		_scene_container.add_child(_editing_scene)
		_editing_scene.hidden.connect(_on_editing_scene_hidden)
		_editing_scene.on_new_session_confirmed.connect(_handle_editing_scene_new_session_confirmed)
	_editing_scene.open_session_data = session_data
	_editing_scene.refresh()
	_editing_scene.show()


func load_session(path):
	session_data.load_from_file(path)
	_session_selected_label.text = "Loaded file:\n" + path.get_file()  # don't clobber up the label with a really long path


func go_to_main_menu():
	_canvas.visible = true


func exit():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()


func _on_exit_pressed():
	exit()


func _on_begin_hypnosis_pressed():
	start_hypno()


func _on_hypno_scene_hidden() -> void:
	go_to_main_menu()


func _on_begin_editing_button_pressed():
	start_editing()


func _on_editing_scene_hidden() -> void:
	go_to_main_menu()


func _handle_editing_scene_new_session_confirmed() -> void:
	session_data = SessionData.new()
	add_child(session_data)
	# TODO: detach old session data???
	_session_selected_label.text = "Loaded file:\nNothing loaded"
	_editing_scene.open_session_data = session_data
	_editing_scene.refresh()
