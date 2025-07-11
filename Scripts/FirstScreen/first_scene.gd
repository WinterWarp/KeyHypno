extends Node2D

var main_menu_ui: CanvasLayer
var SessionSelectedLabel: Label
var scene_container: Node2D
var selectedSessionPath: String
var reader: ZIPReader
var session_data : SessionData

var hypno_scene_res: Resource
var hypno_scene: Node2D
var hypno_scene_audio_player: AudioStreamPlayer
var hypno_scene_subliminal_label: Label

var editing_scene_res: Resource
var editing_scene: EditingScene

const HYPNO_SCENE_PATH = "res://Scenes/HypnoScene.tscn"
const EDITING_SCENE_PATH = "res://Scenes/EditingScene.tscn"


func _ready():
	main_menu_ui = $MainMenuUI
	SessionSelectedLabel = $MainMenuUI/SessionSelectedLabel
	scene_container = $SceneContainer
	ResourceLoader.load_threaded_request(HYPNO_SCENE_PATH)
	ResourceLoader.load_threaded_request(EDITING_SCENE_PATH)
	session_data = SessionData.new()
	add_child(session_data)


func start_hypno():
	if hypno_scene == null:
		hypno_scene_res = ResourceLoader.load_threaded_get(HYPNO_SCENE_PATH)
		hypno_scene = hypno_scene_res.instantiate()
		scene_container.add_child(hypno_scene)
		hypno_scene_audio_player = $SceneContainer/HypnoScene/Control/ASPlayer2D
		hypno_scene_subliminal_label = $SceneContainer/HypnoScene/CanvasLayer/sub
		hypno_scene_audio_player.finished.connect(_on_play_finished)
		hypno_scene.hidden.connect(_on_hypno_scene_hidden)
	hypno_scene.set_visibility(true)
	main_menu_ui.visible = false
	hypno_scene.active_session_data = session_data
	hypno_scene.zip_reader = reader
	hypno_scene.begin_session()


func start_editing():
	if editing_scene == null:
		editing_scene_res = ResourceLoader.load_threaded_get(EDITING_SCENE_PATH)
		editing_scene = editing_scene_res.instantiate()
		scene_container.add_child(editing_scene)
		editing_scene.hidden.connect(_on_editing_scene_hidden)
		editing_scene.on_new_session_confirmed.connect(_handle_editing_scene_new_session_confirmed)
	editing_scene.open_session_data = session_data
	editing_scene.refresh()
	editing_scene.show()
	#editing_scene.set_visibility(true)
	main_menu_ui.visible = false


func setSessionPath(path):
	selectedSessionPath = path
	session_data.load_from_file(path)
	SessionSelectedLabel.text = "Loaded file:\n" + path.get_file()  # don't clobber up the label with a really long path


func go_to_main_menu():
	if hypno_scene != null:
		hypno_scene.set_visibility(false)
	#if editing_scene != null:
		#editing_scene.set_visibility(false)
	main_menu_ui.visible = true


func exit():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()


func _on_exit_pressed():
	exit()


func _on_begin_hypnosis_pressed():
	start_hypno()


func _on_play_finished():
	go_to_main_menu()


func _on_hypno_scene_hidden() -> void:
	go_to_main_menu()


func _on_begin_editing_button_pressed():
	start_editing()


func _on_editing_scene_hidden() -> void:
	go_to_main_menu()


func _handle_editing_scene_new_session_confirmed() -> void:
	session_data = SessionData.new()
	add_child(session_data)
	SessionSelectedLabel.text = "Loaded file:\nNothing loaded"
	editing_scene.open_session_data = session_data
	editing_scene.refresh()
