extends Sprite2D

var losTexture = load("res://assets/sprites/unitLoS.png")

func _ready() -> void:
	for i in get_node("/root/game/navMesh/Walls").find_children("o"):
		#i.occluder_light_mask = 1
		$occluders.add_child(i.duplicate())
	pass

func _process(delta) -> void:
	
	queue_redraw()

	
	# -----------------------------------------------------------------------------------------
	
	
	var diff = $loSes.get_children().size() - globals.playerUnitsNode.get_children().size()
	
	if diff == 0:
		pass
	elif diff < 0:
		for i in range(0,abs(diff)):
			var toAdd = PointLight2D.new()
			$loSes.add_child(toAdd)
	elif diff > 0:
		for i in range(0,diff):
			$loSes.get_child(0).queue_free()
	
	var iter = 0
	for i in globals.playerUnitsNode.get_children():
		var toAdd = $loSes.get_child(iter)
		
		#toAdd.scale = globals.cameraNode.zoom * Vector2(5,5)
		toAdd.texture = losTexture
		toAdd.position =  (i.global_position)
		toAdd.rotation = i.lookDir-PI/2
		toAdd.offset = Vector2(0,360)
		toAdd.enabled = true
		
		#toAdd.range_layer_min = 0
		#toAdd.range_layer_max = 0
		#toAdd.shadow_item_cull_mask = 0
		toAdd.shadow_enabled = true
		#toAdd.modulate = Color(1.0, 1.0, 1.0, 0.369)
		iter += 1
		pass
		
func _draw() -> void:
	if 1==0:
		for i in globals.playerUnitsNode.get_children():
			var poly = [globals.globalToScreenPos(i.global_position) - position]
			
			#print(poly[0])
			
			poly.append(poly[0]+Vector2(1000,0).rotated(i.lookDir + 1))
			poly.append(poly[0]+Vector2(1000,0).rotated(i.lookDir - 1))
			#toAdd.modulate = Color(1.0, 1.0, 1.0, 0.369)
			
			draw_colored_polygon(poly, Color(1.0, 1.0, 1.0, 1.0))

	var iter = 0
	for i in $occluders.get_children():
		#draw_circle(i.position,5,Color(0.583, 0.504, 0.463, 1.0))
		iter += 1
	print(iter)
