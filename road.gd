class_name road extends Node

var positions = []
var type 

func addcoords(lat, lon):
	var position = coordsToPosition(lat, lon)
	positions[positions.size()] = position

func settype(rtype):
	type = rtype

func coordsToPosition(lat, lon):
	#TEMP, change depending on how coords translate to pos
	var position = [lon, -lat]
	return position
