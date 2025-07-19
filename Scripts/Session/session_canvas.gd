extends CanvasLayer

var session_data: SessionData
var player: AudioStreamPlayer
var subliminal_label: Label
var debug_label: Label
@onready
var interact_label: Label = $InteractLabel


func _ready():
	subliminal_label = $sub
	player = get_node("../Control/ASPlayer2D")
	debug_label = $DebugLabel


func _process(_delta: float):
	if session_data != null && visible:
		draw_session()

func draw_session():
	var active_elements: Array[SessionElement] = session_data.get_active_elements()
	
	var active_subliminals = active_elements.filter(
		func(element: SessionElement): return element is SessionElement_Subliminal
	)
	if active_subliminals.is_empty():
		subliminal_label.visible = false
	else:
		subliminal_label.visible = true
		subliminal_label.text = active_subliminals[0].get_current_message()
		
	var active_audio = active_elements.filter(
		func(element: SessionElement): return element is SessionElement_Audio
	)
	if active_audio.size() == 0  && player.playing:
		player.stop()
		player.stream = null
	elif active_audio.size() > 0 && !session_data._paused:
		var audio_data: PackedByteArray = active_audio[0].get_audio_data()
		if !player.is_playing_data(audio_data):
			var audio_ext: String = active_audio[0].get_audio_ext()
			player.play_ext(audio_data, audio_ext)
		
	var active_interacts = active_elements.filter(
		func(element: SessionElement): return element is SessionElement_Interact
	)
	if active_interacts.is_empty():
		interact_label.visible = false
	else:
		var awaited_interact: ButtonInteract = active_interacts[0].get_awaited_interact()
		if awaited_interact == null:
			interact_label.visible = false
		else:
			interact_label.visible = true
			var key_string: String = OS.get_keycode_string(awaited_interact.get_bound_key())
			var hold_time: float = awaited_interact.get_hold_time()
			if hold_time > 0.0:
				interact_label.text = "Hold the " + key_string + " key for " + str(hold_time) + " seconds."
			else:
				interact_label.text = "Press the " + key_string + " key."
	
	#var debug_string: String = "%.1f" % session_data._global_time
	#debug_label.text = debug_string

	#for session_element : SessionElement in active_elements:
	#if(session_element is SessionElement_Subliminal):
	#draw_subliminal(session_element)

#func draw_subliminal(var subliminal : SessionElement):

func _input(event: InputEvent) -> void:
	if session_data == null:
		return
		
	for active_element: SessionElement in session_data.get_active_elements():
		active_element._input(event)
	
