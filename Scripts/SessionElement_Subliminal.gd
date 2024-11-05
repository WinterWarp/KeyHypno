class_name SessionElement_Subliminal
extends SessionElement

var _messages : Array[String];

func _begin_element():
	super._begin_element()
	#load_file("TestSave.hypsav")
	#save_file("TestSave2.hypsav")
	print("subliminal started")

func _process_element(delta : float):
	#print("subliminal tick")
	var StillRunning = super._process_element(delta)
	if !StillRunning:
		return false
	return true
		
func _end_element():
	super._end_element()
	print("subliminal ended")
	
func save_file(path):
	var file = FileAccess.open(path, FileAccess.WRITE)
	for message in _messages:
		file.store_string(message + "\n")
	
func load_file(path):
	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_as_text()
	print(content)
	var content_packed_array = content.split("\n")
	print("packed array: ", content_packed_array.size())
	for packed_string in content_packed_array:
		_messages.append(packed_string)
