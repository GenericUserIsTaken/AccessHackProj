extends Node

var data : PackedStringArray

#var url := 'https://www.soundtransit.org/ride-with-us/routes-schedules/1-line?direction=0&at=1739692800000&view=table&route_tab=arrivals&stops_0=40_N23%2C40_S01&stops_1=40_S01%2C40_N23'
#var testurl := 'https://api.pugetsound.onebusaway.org/api/where/arrivals-and-departures-for-stop/1_75403.json?key=5654bb33-edab-4322-8688-94b9d262abe4\
#&minutesAfter=5&minutesBefore=1'

'''
"40_S01","40_C37","40_C35","40_C29","40_C27","40_C25","40_C23","40_C19","40_C15","40_N03","40_N05","40_N07","40_N09","40_N11","40_N15","40_N17","40_N19","40_N23"
'''

var url = 'https://api.pugetsound.onebusaway.org/api/where/stops-for-route/<route_placeholder>.json?key=<key_placeholder>'
const route_id := "40_100479"
const key := "5654bb33-edab-4322-8688-94b9d262abe4"

# Called when the node enters the scene tree for the first time.
func _ready():
	
	url = url.replace("<route_placeholder>", route_id)
	url = url.replace("<key_placeholder>", key)
	print(url)
	
	$HTTPRequest.request(url)

func _on_http_request_request_completed(result, response_code, headers: PackedStringArray, body: PackedByteArray) -> void:
	print("http request completed")
	var response = body.get_string_from_utf8()
	response = JSON.parse_string(response) # as a dictionary
	response = JSON.stringify(response, "    ") # back into a string
	save_to_file("res://data/testout.json", response)
	
	
	
	
	
	"""
	var json = JSON.new()
	var error = json.parse(response)
	print(json.get_error_message())
	"""
	
	"""if 'soundtransit.org/ride' not in url:
		print("url not found correctly, exiting")
		return
	
	print("url found")
	var start_index = response.find('"st_transit"')
	response = response.substr(start_index)
	
	var brackets = 0
	var end_on = 0
	for i in response.length():
		var char = response[i]
		if char == '{':
			brackets += 1
		elif char == '}':
			brackets -= 1
			if brackets <= 0:
				print("ended on ", i)
				end_on = i
				break
	
	response = response.left(end_on + 1)"""

func save_to_file(path, content):
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(content)
