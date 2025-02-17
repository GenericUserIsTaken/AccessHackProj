extends Control

var arr2d = []

func _ready() -> void:
	var file_path = "res://platfroms.txt"
	for i in range(24):
		arr2d.append([])
		for j in range(3):
			arr2d[i].append(j)
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		var count = 0;
		while not file.eof_reached():
			var line = file.get_line()
			for i in range(3):
				if(i < 2):
					arr2d[count][i] = line.substr(0, line.find(','))
					line = line.substr(line.find(',') + 1)
				else:
					arr2d[count][i] = line
			if (count < 23):
				count+=1
			
		file.close()
		arr2d.remove_at(23)
