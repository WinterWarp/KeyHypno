extends AudioStreamPlayer

@export var amplitude: float = 0.2 


const SAMPLE_RATE: float = 44100.0

var left_phase: float = 0.0
var right_phase: float = 0.0
var left_frequency: float = 440.0
var right_frequency: float = 440.0

var generator: AudioStreamGenerator
var playback: AudioStreamGeneratorPlayback

func _ready():
	generator = AudioStreamGenerator.new()
	generator.mix_rate = SAMPLE_RATE
	generator.buffer_length = 0.1
	stream = generator

func begin_playback(new_left_frequency: float, new_right_frequency: float):
	self.left_frequency = new_left_frequency
	self.right_frequency = new_right_frequency
	left_phase = 0.0
	right_phase = 0.0
	play()
	playback = get_stream_playback()

func stop_playback():
	stop()
	playback = null

func _process(_delta):
	if not playing:
		return
	playback = get_stream_playback()
	if playback == null:
		return
	fill_buffer()

func fill_buffer():
	var frames_to_fill = playback.get_frames_available()
	for i in range(frames_to_fill):
		var left_value = sin(left_phase * TAU) * amplitude
		var right_value = sin(right_phase * TAU) * amplitude

		left_phase += left_frequency / SAMPLE_RATE
		right_phase += right_frequency / SAMPLE_RATE

		left_phase = fmod(left_phase, 1.0)
		right_phase = fmod(right_phase, 1.0)

		playback.push_frame(Vector2(left_value, right_value))
