extends Node
## This is the menu that contains all loading user interface.
class_name UILoadMenu

var _loadMenuManager: LoadMenuManager
## This is our Object that'll be used to hold save info
@export var LoadGameItemObject: PackedScene

func _ready() -> void:
	_loadMenuManager = get_node("LoadMenuManager")
	# We don't need this for now as it doesn't work.
	#LoadAllSaves(_loadMenuManager.loadedLoadList)

func AddLoadGameItemObject(infoDict: Dictionary[String, Variant]) -> void:
	var loadedObject: LoadGameItem = LoadGameItemObject.instantiate()
	loadedObject.saveNameLabel = infoDict["Name"]
	loadedObject.dateLabel = infoDict["Date"]
	loadedObject.versionLabel = infoDict["Save"]
	loadedObject.infoLabel = infoDict["SomeInfo"]

## This will load all saves
func LoadAllSaves(savesList: Array[Dictionary]) -> void:
	pass
	# for item in savesList:
	# AddLoadGameItem(item)
