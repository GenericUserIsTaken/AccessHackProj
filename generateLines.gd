class_name generateLines extends Node2D

func generateLines(roadArray):
	for i in range(roadArray.size()):
		
		#NOT FINISHED, need to figure out how color 
		#relates to type
		#line2Ds[i].color = Color("red")
		if roadArray[i].containsType("highway"):
			var line = Line2D.new()
			for j in range(roadArray[i].positions.size()):
					line.add_point(roadArray[i].positions[j], line.get_point_count())
			self.call_deferred("add_child", line)
		else:
			print(roadArray[i].typeStr)
	print("done")
