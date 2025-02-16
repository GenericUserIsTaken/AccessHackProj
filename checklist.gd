extends Control

@onready var a_list = %ActivitiesList
@onready var c_list = %ChosenList

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	a_list.create_item()
	
	var json = JSON.new()
	var activities = JSON.parse_string(FileAccess.get_file_as_string("res://data/activities.json"))
	
	for activity_name in activities:
		var activity = a_list.create_item()
		activity.set_text(0, activity_name.capitalize())
		#activity.collapsed = true
		
		for catagory_name in activities[activity_name]:
			var catagory = a_list.create_item(activity)
			catagory.set_cell_mode(0, TreeItem.CELL_MODE_CHECK)
			catagory.set_editable(0, true)
			catagory.set_text(0, catagory_name.capitalize())
			catagory.set_metadata(0, catagory_name)

func _on_activities_list_item_edited() -> void:
	record_checked_catagories()

func record_checked_catagories():
	
	var checked_list = []
	
	var tree_node = $"%ActivitiesList".get_root().get_first_child()
	while tree_node != null:
		
		if tree_node.is_checked(0):
			checked_list.append(tree_node.get_metadata(0))
		
		tree_node = tree_node.get_next_in_tree()
	
	print(checked_list)
