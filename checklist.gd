extends Control

@onready var a_list = %ActivitiesList
@onready var p_list = %PlannedList

#              0         1          2            3           4         5           6
const DAYS = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

@onready var start_day = int(%StartDaySelector.selected)
@onready var plan_length = int(%PlanLengthSelector.value)

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
	a_list.clear()
	a_list.create_item()
	a_list.set_column_title(0, "Activities")
	a_list.set_column_title_alignment(0, HORIZONTAL_ALIGNMENT_CENTER)
	
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
	
	#print("chosen_catagories", chosen_catagories)#TESTING
	
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
	
	#print("Global.activity_pools", Global.activity_pools)#TESTING
	
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
			if shuffle_pool_index >= Global.activity_pools[activity].size():
				shuffle_pool_index = 0
				Global.activity_pools[activity].shuffle()
	
	#print("Global.planned_locations", Global.planned_locations)#TESTING
	
	rebuild_chosen_list()

func rebuild_chosen_list():
	p_list.clear()
	p_list.create_item()
	p_list.set_column_title(0, "Suggested Plan")
	p_list.set_column_title_alignment(0, HORIZONTAL_ALIGNMENT_CENTER)
	
	# rebuild the tree nodes
	for day_name in Global.planned_locations:
		var day = p_list.create_item()
		day.set_text(0, day_name)
		
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
		planned_days.append(day + " (" + str(i + 1) + ")")
	return planned_days

func _on_activities_list_column_title_clicked(column: int, mouse_button_index: int) -> void:
	toggle_first_layer_collapsed(a_list)

func _on_planned_list_column_title_clicked(column: int, mouse_button_index: int) -> void:
	toggle_first_layer_collapsed(p_list)

func toggle_first_layer_collapsed(traverse_tree):
	var should_collapse_all = not traverse_tree.get_root().is_any_collapsed()
	
	# apply collapse toggle to all of them
	var tree_node = traverse_tree.get_root().get_first_child()
	while tree_node != null:
		tree_node.collapsed = should_collapse_all
		tree_node = tree_node.get_next()

func _on_option_button_item_selected(index: int) -> void:
	start_day = index
	shuffle_planned_locations()

func _on_spin_box_value_changed(value: float) -> void:
	plan_length = int(value)
	shuffle_planned_locations()
