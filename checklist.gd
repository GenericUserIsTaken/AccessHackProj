extends Control

@onready var a_list = %ActivitiesList
@onready var c_list = %ChosenList

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

func _on_activities_list_item_edited() -> void:
	
	# rebuild a list of all chosen activities
	Global.chosen_catagories.clear()
	
	var tree_node = a_list.get_root().get_first_child()
	while tree_node != null:
		
		if tree_node.is_checked(0):
			var activity_as_string = tree_node.get_metadata(0)
			Global.chosen_catagories.append(activity_as_string)
		
		tree_node = tree_node.get_next_in_tree()

func rebuild_chosen_list():
	c_list.clear()
	c_list.create_item()
	
	# get a list of each activity we need to pick one from
	var activities_to_fill = Global.activities.keys()
	
	# setup a dictionary of all the catagory pools we need to fill and pick from
	var catagory_pools = {}
	for activity in activities_to_fill:
		catagory_pools[activity] = []
	
	# read chosen activities and load them into the pools to randomly pick from
	for item_path in Global.chosen_activities:
		var item_path_array = item_path.split(",")
		catagory_pools[item_path_array[0]].append(item_path_array[1])
	
	# fill in each day using the activity pools
	var plan_days = get_plan_days()
	Global.plan_activities.clear()
	for activity in catagory_pools:
		# if no catagories were chosen for this activity, skip it
		if catagory_pools[activity].is_empty(): continue
		
		# will pick from a shuffled bag without replacement, reshuffle once empty
		catagory_pools[activity].shuffle()
		var shuffle_pool_index = 0
		for day in plan_days:
			
			# set the activity for the day
			Global.plan_activities[day][activity] = catagory_pools[activity][shuffle_pool_index]
			
			# reshuffle if run through the entire bag
			shuffle_pool_index += 1
			if shuffle_pool_index >= catagory_pools[activity].length():
				shuffle_pool_index = 0
				catagory_pools[activity].shuffle()
	
	#TESTING fix this lmao
	# build the tree nodes
	for day_name in Global.plan_activities:
		var day = c_list.create_item()
		for activity_name in Global.plan_activities[day_name]:
			var activity = c_list.create_item(day)
			activity.set_text(0, Global.plan_activities[day_name][activity_name])
			activity.set_metadata(0, activity_name + "," + Global.plan_activities[day_name][activity_name])

# returns a list of day names based on the current start day and plan length
func get_plan_days() -> Array:
	var plan_days = []
	for i in plan_length:
		var day_index = (start_day + i) % 7
		var day = DAYS[day_index]
		plan_days.append(day + " " + str(plan_days.count(day) + 1))
	return plan_days
