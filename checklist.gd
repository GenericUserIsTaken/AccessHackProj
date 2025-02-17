extends Control

@onready var a_list = %ActivitiesList
@onready var p_list = %PlannedList

#              0         1          2            3           4         5           6
const DAYS = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

var start_day = 0
var plan_length = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# if the json is loaded already, immediately load the activities list
	# otherwise, wait for the loaded signal from the Global script
	if Global.has_loaded_activities_json:
		rebuild_activities_list()
	else:
		Global.loaded_activities_json.connect(_on_loaded_activities_json)

func _on_loaded_activities_json():
	rebuild_activities_list()

func rebuild_activities_list():
	# build a tree from the json file of activities
	a_list.create_item()
	
	for activity_name in Global.activities:
		var activity = a_list.create_item()
		activity.set_text(0, activity_name.capitalize())
		
		for catagory_name in Global.activities[activity_name]:
			var catagory = a_list.create_item(activity)
			catagory.set_cell_mode(0, TreeItem.CELL_MODE_CHECK)
			catagory.set_editable(0, true)
			catagory.set_text(0, catagory_name.capitalize())
			catagory.set_metadata(0, activity_name + "," + catagory_name)
	
	update_activity_pools()

func _on_activities_list_item_edited() -> void:
	update_activity_pools()

func update_activity_pools():
	# build a list of all chosen activities
	var chosen_catagories = []
	
	var tree_node = a_list.get_root().get_first_child()
	while tree_node != null:
		
		if tree_node.is_checked(0):
			var activity_as_string = tree_node.get_metadata(0)
			chosen_catagories.append(activity_as_string)
		
		tree_node = tree_node.get_next_in_tree()
	
	print("chosen_catagories", chosen_catagories)#TESTING
	
	# setup a dictionary of locations to choose from per activity
	Global.activity_pools.clear()
	for activity in Global.activities.keys():
		Global.activity_pools[activity] = []
	
	# read chosen catagories and load them into the pools to randomly pick from
	for catagory_path in chosen_catagories:
		var catagory_path_array = catagory_path.split(",")
		var activity = catagory_path_array[0]
		var catagory = catagory_path_array[1]
		for location in Global.activities[activity][catagory]:
			Global.activity_pools[activity].append(catagory + "," + location)
	
	print("Global.activity_pools", Global.activity_pools)#TESTING
	
	# update the output tree
	shuffle_planned_locations()

func shuffle_planned_locations():
	# fill in each day using locations from the activity pools
	var planned_days = get_planned_days()
	Global.planned_locations.clear()
	for activity in Global.activity_pools:
		# if no catagories were chosen for this activity, skip it
		if Global.activity_pools[activity].is_empty(): continue
		
		# will pick from a shuffled bag without replacement, reshuffle once empty
		Global.activity_pools[activity].shuffle()
		var shuffle_pool_index = 0
		for day in planned_days:
			if not Global.planned_locations.has(day): Global.planned_locations[day] = {}
			
			# set the activity for the day
			Global.planned_locations[day][activity] = Global.activity_pools[activity][shuffle_pool_index]
			
			# reshuffle if traversed through the entire bag
			shuffle_pool_index += 1
			if shuffle_pool_index >= Global.activity_pools[activity].length():
				shuffle_pool_index = 0
				Global.activity_pools[activity].shuffle()
	
	rebuild_chosen_list()

func rebuild_chosen_list():
	# rebuild the tree nodes
	p_list.clear()
	p_list.create_item()
	for day_name in Global.planned_locations:
		var day = p_list.create_item()
		for activity_name in Global.planned_locations[day_name]:
			var location_path_array = Global.planned_locations[day_name][activity_name].split(",")
			var catagory_name = location_path_array[0]
			var location_name = location_path_array[1]
			
			# create the node with the info of location and path
			var location = p_list.create_item(day)
			location.set_text(0, location_name.capitalize())
			location.set_metadata(0, activity_name + "," + catagory_name + "," + location_name)

# returns a list of day names based on the current start day and plan length
func get_planned_days() -> Array:
	var planned_days = []
	for i in plan_length:
		var day_index = (start_day + i) % 7
		var day = DAYS[day_index]
		# if the length of the plan will result in multiple of the same day, number them
		# "Monday" -> "Monday (1)"
		if plan_length > 7:
			day += " (" + str(planned_days.count(day) + 1) + ")"
		planned_days.append(day)
	return planned_days
