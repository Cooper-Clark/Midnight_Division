extends Node

## This is a temporary holder information for when we eventually save or we load into with
var tempGameInfoDict: Dictionary[String, Variant]

func _ready() -> void:
	# This will create a save folder if it doesn't exist
	if (DirAccess.dir_exists_absolute("user://saves")):
		print("A saves folder already exists")
	else:
		DirAccess.make_dir_absolute("user://saves")
