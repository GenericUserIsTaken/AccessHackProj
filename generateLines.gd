class_name generateLines extends Node2D

func generateLines(railroad):
	
	#NOT FINISHED, need to figure out how color 
	#relates to type
	#line2Ds[i].color = Color("red")
	var line = Line2D.new()
	line.width = 1;
	for j in range(railroad.positions.size()):
			line.add_point(railroad.positions[j], line.get_point_count())
	self.call_deferred("add_child", line)
#else:
	#print(roadArray[i].typeStr)
	print("done")
