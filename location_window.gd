extends Control

# populate the location info window by looking up a location path from Global
func set_info_from_path(path):
	var path_array = path.split(",")
	var activity_name = path_array[0]
	var catagory_name = path_array[1]
	var location_name = path_array[2]
	
	var location_info = Global.activities[activity_name][catagory_name][location_name]
	
	%Attribute_Name.text = location_name
	%Attribute_Address.text = location_info["address"]
	%Attribute_Hours.text = location_info["hours"]
	%Attribute_Link.text = location_info["link"]
	%Attribute_Link.uri = location_info["link"]
	%Attribute_Description.text = location_info["description"]

func _on_close_location_window_pressed() -> void:
	queue_free()
