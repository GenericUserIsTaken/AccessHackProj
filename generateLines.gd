class_name generateLines extends Node2D

func generateLines(roadArray):
	var line2Ds = []
	for i in range(roadArray.size()):
		line2Ds.append(Line2D.new())
		#NOT FINISHED, need to figure out how color 
		#relates to type
		#line2Ds[i].color = Color("red")
		
		for j in range(roadArray[i].positions.size()):
			line2Ds[i].add_point(roadArray[i].positions[j], line2Ds[i].get_point_count())
		self.call_deferred("add_child", line2Ds[i])
	print("done")
