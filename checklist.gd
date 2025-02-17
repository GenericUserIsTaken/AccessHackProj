extends Control

@onready var a_list = %ActivitiesList
@onready var c_list = %ChosenList

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
	Global.chosen_activities.clear()
	
	var tree_node = a_list.get_root().get_first_child()
	while tree_node != null:
		
		if tree_node.is_checked(0):
			var activity_as_string = tree_node.get_metadata(0)
			Global.chosen_activities.append(activity_as_string)
		
		tree_node = tree_node.get_next_in_tree()
	
	print(Global.chosen_activities)

func rebuild_chosen_list():
	c_list.clear()
	c_list.create_item()
	
	
	
	for item_path in Global.chosen_activities:
		var item_path_array = item_path.split(",")
		
