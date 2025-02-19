extends Node

signal loaded_activities_json()
signal rebuild_scheduler()
var has_loaded_activities_json := false

# the json loaded as a dictionary
# activities (food, entertainment)
#     catagories (mexican, city parks)
#         locations (restaurant1, park1)
var activities = {}

# groupings of locations from those catagories to shuffle from
var activity_pools = {}

# the randomly selected activities listed as the plan
# days (Monday 1, Tuesday 1)
#     activities (food, entertainment) <1 of each per day!>
#         locations (restaurant1, park1) <1 per each activity!>
var planned_locations = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("hello")
	load_activities_json()

func load_activities_json():
	activities = JSON.parse_string(FileAccess.get_file_as_string("res://data/activities.json"))
	activities["user_submitted"] = {}
	activities["user_submitted"]["suggested_locations"] = {}
	
	has_loaded_activities_json = true
	loaded_activities_json.emit()
	print("loaded activities json")
