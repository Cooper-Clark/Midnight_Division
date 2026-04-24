extends Node2D

@export var waitRange: Array[int] = [1, 1]
@export var burstRange: Array[int] = [1, 1]

var leftInBurst = 0

func _on_wait_timer_timeout() -> void:
	if leftInBurst > 0:
		var newEnemy = load("res://scenes/unit.tscn").instantiate()
		newEnemy.set_script(load("res://scripts/units/enemyUnitScript.gd"))
		newEnemy.global_position = global_position + Vector2(randf_range(-20,20),randf_range(-20,20))
		get_node("/root/game/units/enemyUnits").add_child(newEnemy)
		print("Rahh!")
		$waitTimer.start(randf_range(0.4,1))
		leftInBurst -= 1
	else:
		$waitTimer.start(randf_range(waitRange[0],waitRange[1]))
		leftInBurst = randi_range(burstRange[0],burstRange[1])
