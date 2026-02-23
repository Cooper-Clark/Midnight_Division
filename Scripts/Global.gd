extends Node

## This is a temporary holder information for when we eventually save or we load into with overall campaign
var tempGameInfoDict: Dictionary[String, Variant]
## This is a temporary holder information for ingame level, should be later stored within tempGameInfoDict
var tempLevelInfoDict: Dictionary[String, Variant]

## Filepath
const savesFolderFilePath: String = "user://saves"

func _ready() -> void:
	# This will create a save folder if it doesn't exist
	if (DirAccess.dir_exists_absolute(savesFolderFilePath)):
		print("A saves folder already exists")
	else:
		DirAccess.make_dir_absolute(savesFolderFilePath)
