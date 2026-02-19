extends Button
class_name UIMenuButton

## This contains the menu that the button should open
@export var otherMenu: Control
## This contains the menu that the button resides in.
@export var currentMenu: Control

func _ready() -> void:
	connect("pressed", _OnPress)

func _OnPress() -> void:
	ChangeMenu()

func ChangeMenu() -> void:
	currentMenu.visible = false
	otherMenu.visible = true
