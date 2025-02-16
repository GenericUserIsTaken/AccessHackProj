class_name road extends Node

var positions = []
var type : Array[String] = []
var typeStr : String = ""

func addcoords(pos):
	positions.append(pos *100 )

func addtype(rtype):
	type.append(rtype)
	typeStr += rtype

func gettype():
	return type
	
func containsType(x):
	return typeStr.contains(x)
