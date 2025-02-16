extends Control

@onready var list = %List

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	list.create_item()
	list.set_column_title(0, "Activities")
	
	var json = JSON.new()
	var activities = JSON.parse_string(FileAccess.get_file_as_string("res://data/activities.json"))
	
	for activity_name in activities:
		var activity = list.create_item()
		activity.set_text(0, activity_name.capitalize())
		#activity.collapsed = true
		
		for catagory_name in activities[activity_name]:
			var catagory = list.create_item(activity)
			catagory.set_cell_mode(0, TreeItem.CELL_MODE_CHECK)
			catagory.set_editable(0, true)
			catagory.set_text(0, catagory_name.capitalize())

	print(activities)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
