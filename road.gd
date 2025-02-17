class_name road extends Node

var upscaleCo = 100
var positions = []
var platformPositions = []
'''
var type : Array[String] = []
var typeStr : String = ""
'''

func addcoords(coord):
	var pos = coordtopos(coord)
	positions.append(pos * upscaleCo)

func addplatformcoords(coord):
	var pos = coordtopos(coord)
	platformPositions.append(pos * upscaleCo)

func coordtopos(coord):
	var pos = Vector2(0,0)
	pos.x = 366.5 * (coord.y + 123.876)
	pos.y = 366.5 * (coord.x - 48.323)
	return pos

'''
func addtype(rtype):
	type.append(rtype)
	typeStr += rtype

func gettype():
	return type
	
func containsType(x):
	return typeStr.contains(x)
'''
