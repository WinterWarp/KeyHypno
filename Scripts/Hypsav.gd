func decode(data: String) -> Array[Resource]:
	# parse data
	var json = JSON.new()
	var error = json.parse(data)
	# verify data
	if error == OK:
		var data_received = json.data
		if typeof(data_received) == TYPE_ARRAY:
			return data_received.sort_custom(func(a, b): return a.time < b.time)  # sort by time so we can assume events are in order
		else:
			print("data is of invalid type")
			return []
	else:
		print(
			"JSON Parse Error: ",
			json.get_error_message(),
			" in ",
			data,
			" at line ",
			json.get_error_line()
		)
		return []


func encode(data: Array[Resource]) -> String:
	return JSON.stringify(data)


func load(session_data: SessionData, data: String) -> void:
	session_data.reset_and_clear()
	var sav = decode(data)
	var ev = sav.events
	for e in ev:
		match e.type:
			"SUBLIMINAL":
				var s = session_data.add_element_of_class(session_data.SubliminalClass)
				s._start_time = e.start_time
				s._end_time = e.end_time
				s._time_per_message = e.time_per_message
				for line in e.messages:
					s._messages.append(line)
			_:
				print("invalid event type" + e.type)
