extends Control

@onready var list = %List

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	list.create_item()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
