extends Node

signal loaded_activities_json()
var has_loaded_activities_json := false

# the json loaded as a dictionary
# activities (food, entertainment)
#     catagories (mexican, city parks)
#         locations (restaurant1, park1)
var activities = {}
# the catagories the user wants the program to randomize from
var chosen_catagories = []
# the randomly selected activities listed as the plan
var planned_locations = []

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
