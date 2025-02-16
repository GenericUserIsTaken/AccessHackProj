extends Node

var data : PackedStringArray

var url := 'https://www.soundtransit.org/ride-with-us/routes-schedules/1-line?direction=0&at=1739692800000&view=table&route_tab=arrivals&stops_0=40_N23%2C40_S01&stops_1=40_S01%2C40_N23'


# Called when the node enters the scene tree for the first time.
func _ready():
	$HTTPRequest.request(url)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	print("httpcompeleted")
	var response = body.get_string_from_utf8()
	print(body)


func _on_http_request_request_completed(result, response_code, headers: PackedStringArray, body: PackedByteArray) -> void:
	print("httpcompeleted")
	var response = body.get_string_from_utf8()
	print(response)
	
	
# Called when the HTTP request is completed.
func _http_request_completed(result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
