extends Control
@onready var LocationName = $MarginContainer/VBoxContainer/HBoxContainer2/LineEdit
@onready var Address = $MarginContainer/VBoxContainer/HBoxContainer3/LineEdit
@onready var Link = $MarginContainer/VBoxContainer/HBoxContainer5/LineEdit
@onready var hours = $MarginContainer/VBoxContainer/HBoxContainer4/LineEdit
@onready var Description = $MarginContainer/VBoxContainer/HBoxContainer6/TextEdit



@onready var Entries = [LocationName, Address, Link, hours, Description]

#Called when Button IS PRESSED DUH 
func _on_button_pressed() -> void:
	for i in Entries.size():
		if(Entries[i].text.is_empty()) : 
			print("empty")
			return
	
	var ActivityData = {}
	ActivityData["address"] = Address.text
	ActivityData["link"] = Link.text
	ActivityData["hours"] = hours.text
	ActivityData["description"] = Description.text
	
	Global.activities ["user_submitted"]["suggested_locations"][LocationName.text] = ActivityData
	Global.rebuild_scheduler.emit()
	
	for j in Entries.size():
		Entries[j].text = ""
	
