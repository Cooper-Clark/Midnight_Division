extends Node2D

var drawBool : bool = false
var thePathToDraw : Array[Vector2] = []

func drawNavPath() -> void:
	var unit = get_parent().get_parent()
	var navAgent = unit.get_node("unitNavAgent")
	var path = navAgent.get_current_navigation_path()
	var nextPoint = navAgent.get_next_path_position()
	
	#draw_circle(globals.globalToScreenPos(unit.global_position + unit.velocity), 2, Color(0.593, 0.297, 0.216, 1.0))
	
	var pathToDraw = [globals.globalToScreenPos(unit.global_position)]
	
	var reachedNewPathPoints = false
	if path:
		for i in path: 
			if reachedNewPathPoints:
				pathToDraw.append(globals.globalToScreenPos(i))
			elif i == nextPoint:
				reachedNewPathPoints = true
				pathToDraw.append(globals.globalToScreenPos(i))
	
	if pathToDraw.size() > 1:
		for i in range(1,pathToDraw.size()):
			draw_line(pathToDraw[i-1], pathToDraw[i], Color(0.187, 0.468, 0.0, 1.0), 1)
			draw_circle(pathToDraw[i], 2, Color(0.187, 0.468, 0.0, 1.0))
			
func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	if drawBool:
		drawNavPath()
