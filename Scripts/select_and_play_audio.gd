extends FileDialog

var selectedfile
var Main: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Main = $"../.."
	pass # Replace with function body.

func _on_FileDialog_file_selected(path: String):
	match path.right(3).to_lower():
		"ogg", "mp3":
			Main.setAudioPath(path)
		_:
			print("unexpected file type")
	

func _on_load_file_pressed():
	popup()
