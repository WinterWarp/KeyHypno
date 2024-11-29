extends CanvasLayer

var session_data : SessionData
var subliminal_label : Label
var debug_label : Label

func _ready():
	subliminal_label = $sub
	debug_label = $DebugLabel

func _process(delta : float):
	if session_data != null:
		draw_session()

func draw_session():
	var active_elements : Array[SessionElement] = session_data.get_active_elements()
	var active_subliminals = active_elements.filter(
			func(element : SessionElement): return element is SessionElement_Subliminal)
	if active_subliminals.is_empty():
		subliminal_label.visible = false
	else:
		subliminal_label.visible = true
		subliminal_label.text = active_subliminals[0].get_current_message()
	var debug_string : String = "%s" % session_data._global_time
	debug_label.text = debug_string
	
	#for session_element : SessionElement in active_elements:
		#if(session_element is SessionElement_Subliminal):
			#draw_subliminal(session_element)
		
#func draw_subliminal(var subliminal : SessionElement):
	
