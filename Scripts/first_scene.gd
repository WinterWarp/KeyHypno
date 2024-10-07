extends Node2D

var MainMenuUI:CanvasLayer
var FileSelectedLabel: Label
var SceneContainer:Node2D
var selectedFilePath:String

var Hypno_scene_res:Resource
var HypnoScene:Node2D
var HSPlayer:AudioStreamPlayer2D


const HYPNO_SCENE_PATH = "res://Scenes/HypnoScene.tscn"

func _ready():
	MainMenuUI = $MainMenuUI
	FileSelectedLabel = $MainMenuUI/FileSelectedLabel
	SceneContainer = $SceneContainer
	ResourceLoader.load_threaded_request(HYPNO_SCENE_PATH)
	
func startHypno():
	if SceneContainer.get_child_count() == 0:
		Hypno_scene_res = ResourceLoader.load_threaded_get(HYPNO_SCENE_PATH)
		HypnoScene = Hypno_scene_res.instantiate()
		SceneContainer.add_child(HypnoScene)
		HypnoScene.set_visibility(true)
		HSPlayer = $SceneContainer/HypnoScene/Control/ASPlayer2D
		HSPlayer.finished.connect(_on_play_finished)
	else:
		SceneContainer.get_child(0).visible = true
		HypnoScene.set_visibility(true)
	loadFromPath(selectedFilePath)
	HSPlayer.play()
	MainMenuUI.visible = false
	
	

func setFilePath(path):
	selectedFilePath = path
	FileSelectedLabel.text = "Loaded file:\n"+path

func loadFromPath(path):
	match path.right(3).to_lower():
		"ogg":
			HSPlayer.stream = AudioStreamOggVorbis.load_from_file(path)
		"mp3":
			var file = FileAccess.open(path, FileAccess.READ)
			var mp3 = AudioStreamMP3.new()
			mp3.data = file.get_buffer(file.get_length())
			HSPlayer.stream = mp3
		_:
			print("unexpected file type")

	
func gotoMainMenu():
	HypnoScene.set_visibility(false)
	MainMenuUI.visible = true
	print(SceneContainer.get_child_count(), " ", SceneContainer.get_children())
	SceneContainer.get_child(0).visible = false
	
func exit():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()


func _on_exit_pressed():
	exit()

func _on_begin_hypnosis_pressed():
	startHypno()
	
func _on_play_finished():
	gotoMainMenu()
