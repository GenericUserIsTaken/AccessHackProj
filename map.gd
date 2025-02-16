extends Panel

var path = "res://map.xml"
var minlat
var minlon
var maxlat
var maxlon
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var parser = XMLParser.new()
	var curRoad = road.new()
	var count2 = 0
	parser.open(path)
	while parser.read() != ERR_FILE_EOF and count2 <= 20000:
		var node_type = parser.get_node_type()
		count2 += 1
		if node_type == XMLParser.NODE_TEXT:
			var node_name = parser.get_node_data()
			if node_name.contains("bounds"):
				minlat = parser.get_named_attribute_value("minlat")
				minlon = parser.get_named_attribute_value("minlon")
				maxlat = parser.get_named_attribute_value("maxlat")
				maxlon = parser.get_named_attribute_value("maxlon")
		if node_type == XMLParser.NODE_ELEMENT:
			var node_name = parser.get_node_name()
			if node_name == "node":
				#print("node y x",parser.get_named_attribute_value("lat"),parser.get_named_attribute_value("lon"))
				curRoad.addcoords(Vector2(float(parser.get_named_attribute_value("lon")),-1*float(parser.get_named_attribute_value("lat"))))
			elif node_name == "tag":
				#print("tag type ", parser.get_named_attribute_value("k"))
				var k = parser.get_named_attribute_value("k")
				if k:
					curRoad.type += k
			else:
				print("unknown data: ",node_name)
				'''
				var attributes_dict = {}
				for idx in range(parser.get_attribute_count()):
					attributes_dict[parser.get_attribute_name(idx)] = parser.get_attribute_value(idx)
				print("The ", node_name, " element has the following attributes: ", attributes_dict)
				'''
		elif parser.get_node_type() == XMLParser.NODE_ELEMENT_END:
			var node_name = parser.get_node_name()
			print(node_name)
			self.add_child(curRoad)
			print(self.get_child_count())
			curRoad = road.new()
	var gL = generateLines.new()
	self.get_parent().call_deferred("add_child", gL)
	gL.generateLines(self.get_children())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
