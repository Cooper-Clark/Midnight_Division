extends Node
class_name SaveMenuManager

## This will be grabbed in the LoadMenu
var loadedSaveList: Array[Dictionary]

# What we eventually want to do is iterate through this folder
# This will grab all the saves in that folder and add them to the [loadedLoadList]
func CreateLoadList() -> void:
	if (DirAccess.dir_exists_absolute("user://saves")):
		pass
	
	
