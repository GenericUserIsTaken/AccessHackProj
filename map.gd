extends Panel

var path = "res://map.xml"
var minlat
var minlon
var maxlat
var maxlon
var coord = Vector2()
var coordcount = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var parser = XMLParser.new()
	var curRoad = road.new()
	var count2 = 0
	parser.open(path)
	while parser.read() != ERR_FILE_EOF :#and count2 <= 20000
		var node_type = parser.get_node_type()
		count2 += 1
		if node_type == XMLParser.NODE_TEXT:
			var node_name = parser.get_node_data()
			if node_name.contains("bounds"):
				minlat = float(parser.get_named_attribute_value("minlat"))
				minlon = float(parser.get_named_attribute_value("minlon"))
				maxlat = float(parser.get_named_attribute_value("maxlat"))
				maxlon = float(parser.get_named_attribute_value("maxlon"))
		if node_type == XMLParser.NODE_ELEMENT:
			var node_name = parser.get_node_name()
			if node_name == "node":
				if minlat && minlon:
					if parser.get_named_attribute_value("lon") && parser.get_named_attribute_value("lat"):
						#print("node y x",parser.get_named_attribute_value("lat"),parser.get_named_attribute_value("lon"))
						var lon = float(parser.get_named_attribute_value("lon"))
						var lat = float(parser.get_named_attribute_value("lat"))
						var skib = Vector2(lon-minlon,(lat-minlat)*-1)
						curRoad.addcoords(skib)
						coordcount +=1;
						coord += skib
				else:
					print("NO MIN FOR NODE")
			elif node_name == "bounds":
				minlat = float(parser.get_named_attribute_value("minlat"))
				minlon = float(parser.get_named_attribute_value("minlon"))
				maxlat = float(parser.get_named_attribute_value("maxlat"))
				maxlon = float(parser.get_named_attribute_value("maxlon"))
			elif node_name == "tag":
				#print("tag type ", parser.get_named_attribute_value("k"))
				var k = parser.get_named_attribute_value("k")
				if k:
					curRoad.addtype(k)
			else:
				continue
				#print("unknown data: ",node_name)
				'''
				var attributes_dict = {}
				for idx in range(parser.get_attribute_count()):
					attributes_dict[parser.get_attribute_name(idx)] = parser.get_attribute_value(idx)
				print("The ", node_name, " element has the following attributes: ", attributes_dict)
				'''
		elif parser.get_node_type() == XMLParser.NODE_ELEMENT_END:
			var node_name = parser.get_node_name()
			self.add_child(curRoad)
			curRoad = road.new()
	var gL = generateLines.new()
	self.get_parent().call_deferred("add_child", gL)
	var cam = Camera2D.new()
	cam.position = Vector2((maxlon-minlon)/2,(maxlat-minlat)/2) * 100
	self.get_parent().call_deferred("add_child",cam)
	var mark = Marker2D.new()
	mark.position =  Vector2((maxlon-minlon)/2,(maxlat-minlat)/2) * 100
	self.get_parent().call_deferred("add_child",mark)
	gL.generateLines(self.get_children(),Vector2())
	parser = null
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
