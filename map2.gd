extends Line2D

var ogLat
var ogLon

var latShift
var lonShift

var posList = []

var path = "res://segments2.xml"
var minlat
var minlon
var maxlat
var maxlon
var coord = Vector2()
var coordcount = 0
# Called when the node enters the scene tree for the first time.

func coordtopos(coord):
	var pos = Vector2(0,0)
	pos.x = 366.5 * (coord.y + 123.876)
	pos.y = 366.5 * -1.5 * (coord.x - 48.323)
	
	latShift  = ogLat - 48.323
	lonShift  = ogLon + 123.876
	
	return pos
func _ready() -> void:
	var mosaic = self.get_parent()
	ogLat = mosaic.latitude
	ogLon = mosaic.longitude
	
	var parser = XMLParser.new()
	var count2 = 0
	parser.open(path)
	while parser.read() != ERR_FILE_EOF :#and count2 <= 20000
		var node_type = parser.get_node_type()
		if node_type == XMLParser.NODE_ELEMENT:
			var node_name = parser.get_node_name()
			if node_name == "node":
				
				if parser.get_named_attribute_value("lon") && parser.get_named_attribute_value("lat"):
					#print("node y x",parser.get_named_attribute_value("lat"),parser.get_named_attribute_value("lon"))
					var lon = float(parser.get_named_attribute_value("lon"))
					var lat = float(parser.get_named_attribute_value("lat"))
					
					posList.append(coordtopos(Vector2(lat, lon)))
				else:
					print("NO MIN FOR NODE")
			
			else:
				continue
				#print("unknown data: ",node_name)
				'''
				var attributes_dict = {}
				for idx in range(parser.get_attribute_count()):
					attributes_dict[parser.get_attribute_name(idx)] = parser.get_attribute_value(idx)
				print("The ", node_name, " element has the following attributes: ", attributes_dict)
				'''
	for minIndex in range(posList.size()):
		var min = 999
		var element
		var minInd = -1
		for j in range(minIndex, posList.size()):
			if (posList[j].y <= min):
				min = posList[j].y
				minInd = j
				element = Vector2(posList[j].x, posList[j].y)
		posList.remove_at(minInd)
		posList.insert(minIndex, element)
		
	for i in range(posList.size()):
		self.add_point(posList[i], self.get_point_count())

	#var #gen = generateLines.new()
	#gen.generateLines(railroad)
	#var gL = generateLines.new()
	#self.get_parent().call_deferred("add_child", gL)
	#var cam = Camera2D.new()
	#cam.position = Vector2((maxlon-minlon)/2,(maxlat-minlat)/2) * 100
	#self.get_parent().call_deferred("add_child",cam)
	#var mark = Marker2D.new()
	#mark.position =  Vector2((maxlon-minlon)/2,(maxlat-minlat)/2) * 100
	#self.get_parent().call_deferred("add_child",mark)
	#gL.generateLines(self.get_children(),Vector2())
	#parser = null
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mosaic = self.get_parent()
	var curLat = mosaic.latitude
	var curLon = mosaic.longitude
	
	var pos = -coordtopos(Vector2(curLat - latShift, curLon - lonShift))
	self.global_position = pos
	pass
