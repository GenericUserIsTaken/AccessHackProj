class_name road extends Node

var upscaleCo = 100
var positions = []
var platformPositions = []
'''
var type : Array[String] = []
var typeStr : String = ""
'''

func addcoords(pos):
	positions.append(pos * upscaleCo)

func addplatformcoords(pos):
	platformPositions.append(pos * upscaleCo)

'''
func addtype(rtype):
	type.append(rtype)
	typeStr += rtype

func gettype():
	return type
	
func containsType(x):
	return typeStr.contains(x)
'''
