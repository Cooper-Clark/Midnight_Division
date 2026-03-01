extends Node

## This is a temporary holder information for when we eventually save or we load into with overall campaign
var tempGameInfoDict: Dictionary[String, Variant] = {
	"Name": "Name", ## Placeholder, but is important
	"Date": "01/01/01", ## Placeholder, Check https://docs.godotengine.org/en/stable/classes/class_time.html
	"Version": "0.01", ## Placeholder, but is important
	
	"IsDogActive": false, ## This could if you want a character to be on ship or not
	"SomeInfo": 1 ## Placeholder, not important will be replaced by relevant information
}

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
