extends Button
## This is a button that exits the player out of the game.
class_name ExitButton

func _ready() -> void:
	connect("pressed", _OnLoadButtonPressed)

func _OnLoadButtonPressed() -> void:
	get_tree().quit()
