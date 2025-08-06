extends CanvasLayer

const END_OF_SESSION_TEXT: String = "END OF SESSION"

var _session_data: SessionData
@onready
var player: AudioStreamPlayer = $SessionAudioPlayer
@onready
var subliminal_label: Label = $SubliminalLabel
@onready
var debug_label: Label = $DebugLabel
@onready
var interact_label: Label = $InteractLabel
@onready
var audio_generator: AudioStreamPlayer = $AudioGen


func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	if _session_data != null && visible:
		draw_session()
	if !visible:
		if player.playing:
			player.stop()
		if audio_generator.playing:
			audio_generator.stop_playback()


func set_session_data(in_session_data: SessionData) -> void:
	if _session_data != null:
		_session_data.on_session_end_reached.disconnect(_handle_session_end_reached)
	_session_data = in_session_data
	_session_data.on_session_end_reached.connect(_handle_session_end_reached)


func draw_session() -> void:
	var active_elements: Array[SessionElement] = _session_data.get_active_elements()
	
	# Subliminals
	var active_subliminals: Array[SessionElement_Subliminal]
	active_subliminals.assign(active_elements.filter(
		func(element: SessionElement): return element is SessionElement_Subliminal
	))
	if _session_data.is_at_end():
		# Don't touch the sub label, it's been updated in _handle_session_end_reached
		pass
	elif active_subliminals.is_empty():
		subliminal_label.visible = false
	else:
		subliminal_label.visible = true
		subliminal_label.text = active_subliminals[0].get_current_message()
	
	# Audio
	var active_audios: Array[SessionElement_Audio]
	active_audios.assign(active_elements.filter(
		func(element: SessionElement): return element is SessionElement_Audio
	))
	if active_audios.size() == 0  && player.playing:
		player.stop_and_clear()
	elif _session_data.is_paused():
		# TODO: This presumably loses the place in the audio stream.
		# Should keep it so it can be resumed.
		player.stop()
	elif active_audios.size() > 0 && !_session_data.is_paused():
		# TODO: support multiple audio streams
		var audio_data: PackedByteArray = active_audios[0].get_audio_data()
		if !player.is_playing_data(audio_data):
			var audio_ext: String = active_audios[0].get_audio_ext()
			player.play_file_data(audio_data, audio_ext)
	
	# Interacts
	var active_interacts: Array[SessionElement_Interact]
	active_interacts.assign(active_elements.filter(
		func(element: SessionElement): return element is SessionElement_Interact
	))
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

	# AudioGen
	var active_audio_gen: Array[SessionElement_AudioGen]
	active_audio_gen.assign(active_elements.filter(
		func(element: SessionElement): return element is SessionElement_AudioGen
	))
	
	if (active_audio_gen.is_empty() and audio_generator.playing) or _session_data.is_paused():
			audio_generator.stop_playback()
			audio_generator.stop()
	elif !active_audio_gen.is_empty() and !audio_generator.playing and !_session_data.is_paused():
		audio_generator.amplitude = active_audio_gen[0].amplitude.get_value()
		audio_generator.begin_playback(
			active_audio_gen[0].left_frequency.get_value(),
			active_audio_gen[0].right_frequency.get_value()
		)


func _input(event: InputEvent) -> void:
	if _session_data == null:
		return
		
	for active_element: SessionElement in _session_data.get_active_elements():
		active_element._input(event)


func _handle_session_end_reached() -> void:
	subliminal_label.visible = true
	subliminal_label.text = END_OF_SESSION_TEXT
	
