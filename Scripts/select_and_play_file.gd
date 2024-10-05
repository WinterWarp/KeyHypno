extends FileDialog

var selectedfile
var ASPlayer2D: AudioStreamPlayer2D
var AL2D: AudioListener2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ASPlayer2D = $"../ASPlayer2D"
	
	popup()
	
	pass # Replace with function body.

func _on_FileDialog_file_selected(path:String):
	print(path)
	print(path.right(3))
	print(path.right(3).to_lower())
	match path.right(3).to_lower():
		"ogg":
			ASPlayer2D.stream = AudioStreamOggVorbis.load_from_file(path)
		"mp3":
			var file = FileAccess.open(path, FileAccess.READ)
			var mp3 = AudioStreamMP3.new()
			mp3.data = file.get_buffer(file.get_length())
			ASPlayer2D.stream = mp3
		_:
			print("unexpected file type")
	ASPlayer2D.play()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_finished() -> void:
	var Error = get_tree().change_scene_to_file("res://Scenes/FirstScene.tscn")
	if Error:
		print("Error %d when changing scene." % Error)
