extends Node2D

func _process(delta: float) -> void:
	queue_redraw()
	
func _draw() -> void:
	draw_circle(Vector2(0,0), 5, Color(randf(), randf(), randf(), 1.0))
	
	for i in get_children():
		draw_line(Vector2(0,0), i.position, Color(randf(), randf(), randf(), 1.0))
