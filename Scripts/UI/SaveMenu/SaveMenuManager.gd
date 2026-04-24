extends Node
class_name SaveMenuManager

const saveLocation: String = "user://saves"

var loadedSaveListPath: Array[String]
## This will be grabbed in the LoadMenu
var loadedSaveList: Array[Dictionary]


signal Saved

func _ready() -> void:
	CreateSaveList()

# What we eventually want to do is iterate through this folder
# This will grab all the saves in that folder and add them to the [loadedLoadList]
func CreateSaveList() -> void:
	
	if (DirAccess.dir_exists_absolute("user://saves")):
		GetSaveFilePaths(saveLocation)
		

#"Name": "Name", ## Placeholder, but is important
#"Date": 1235234, ## Placeholder, Check https://docs.godotengine.org/en/stable/classes/class_time.html, float: Unix Time
#"Version": "0.01", ## Placeholder, but is important
#
#"IsDogActive": false, ## This could if you want a character to be on ship or not
#"SomeInfo": 1 ## Placeholder, not important will be replaced by relevant information

## Look into [Global] to find Dictionary of save
func SaveGame() -> bool:
	# This will get version in application settings
	SaveSystem.tempGameInfoDict["Version"] = ProjectSettings.get_setting("application/config/version")
	
	# Then we save it to a file.
	var file := FileAccess.open_encrypted_with_pass(SaveSystem.savesFolderFilePath, FileAccess.WRITE, "Wint1ium")
	file.store_var(SaveSystem.tempGameInfoDict)
	file.close()
	Saved.emit()
	return true

func GetSaveFilePaths(filePath: String) -> void:
	var dir := DirAccess.open(filePath)
	
	if dir:
		dir.list_dir_begin()
		var fileName = dir.get_next()
		while fileName != "":
			if dir.current_is_dir():
				print(dir.get_current_dir() + "/" + fileName)
			else:
				var savePath = dir.get_current_dir() + "/" + fileName
				print(str(self) + str(savePath))
				loadedSaveListPath.push_back(savePath)
			fileName = dir.get_next()
	else:
		push_error("An error occurred when trying to access the path.")
