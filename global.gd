extends Node

signal loaded_activities_json()
var has_loaded_activities_json := false

var activities = {}
var chosen_activities = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("hello")
	load_activities_json()

func load_activities_json():
	var json = JSON.new()
	activities = JSON.parse_string(FileAccess.get_file_as_string("res://data/activities.json"))
	has_loaded_activities_json = true
	loaded_activities_json.emit()
	print("loaded activities json")
