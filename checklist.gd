extends Control

@onready var list = %List

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	list.create_item()
	
	var json = JSON.new()
	var activities = JSON.parse_string(FileAccess.get_file_as_string("res://data/activities.json"))
	
	for catagory_name in activities:
		var catagory = list.create_item()
		catagory.set_text(0, catagory_name.capitalize())
		
		catagory

	print(activities)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
