extends Node2D

var MainMenuUI: CanvasLayer
var MP3SelectedLabel: Label
var SubSelectedLabel: Label
var SceneContainer: Node2D
var selectedAudioPath: String
var selectedSubPath: String

var Hypno_scene_res: Resource
var HypnoScene: Node2D
var HSPlayer: AudioStreamPlayer2D
var SubLabel


const HYPNO_SCENE_PATH = "res://Scenes/HypnoScene.tscn"

func _ready():
	MainMenuUI = $MainMenuUI
	MP3SelectedLabel = $MainMenuUI/MP3SelectedLabel
	SubSelectedLabel = $MainMenuUI/SubSelectedLabel
	SceneContainer = $SceneContainer
	ResourceLoader.load_threaded_request(HYPNO_SCENE_PATH)
	
func startHypno():
	if SceneContainer.get_child_count() == 0:
		Hypno_scene_res = ResourceLoader.load_threaded_get(HYPNO_SCENE_PATH)
		HypnoScene = Hypno_scene_res.instantiate()
		SceneContainer.add_child(HypnoScene)
		HypnoScene.set_visibility(true)
		HSPlayer = $SceneContainer/HypnoScene/Control/ASPlayer2D
		SubLabel = $SceneContainer/HypnoScene/CanvasLayer/sub
		HSPlayer.finished.connect(_on_play_finished)
	else:
		SceneContainer.get_child(0).visible = true
		HypnoScene.set_visibility(true)
	loadAudioFromPath(selectedAudioPath)
	loadSubFromPath(selectedSubPath)
	HSPlayer.play()
	MainMenuUI.visible = false
	
	
func setAudioPath(path):
	selectedAudioPath = path
	MP3SelectedLabel.text = "Loaded file:\n" + path

func setSubPath(path):
	selectedSubPath = path
	SubSelectedLabel.text = "Loaded file:\n" + path

func loadAudioFromPath(path):
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

func loadSubFromPath(path):
	if path.right(3).to_lower() == "txt":
		var file = FileAccess.open(path, FileAccess.READ)
		var text = file.get_as_text()
		var list = text.split("\n")
		print(list)
		SubLabel.list = list
		SubLabel.text = list[0]
	else:
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
