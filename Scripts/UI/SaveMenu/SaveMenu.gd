extends Control
## This is the menu that contains all loading user interface.
class_name UISaveMenu

var _saveMenuManager: SaveMenuManager
## This is our Object that'll be used to hold save info
var _saveGameItemObject: PackedScene = preload("res://Scenes/Menus/SaveMenu/SaveGameItem.tscn")
@onready var itemContainer: VBoxContainer = $"../SaveMenu/ScrollContainer/ItemContainer"

## @experimental
## This will be removed, it is only used to test and showcase
var _fakeItem: Dictionary[String, Variant] = {
	"Name": "Name", # Placeholder, but is important
	"Date": "01/01/01", # Placeholder, Check https://docs.godotengine.org/en/stable/classes/class_time.html
	"Version": "0.01", # Placeholder, but is important
	
	"SomeInfo": 1 # Placeholder, not important will be replaced by relevant information
}

func _ready() -> void:
	_saveMenuManager = get_node("SaveMenuManager")
	# We don't need this for now as it doesn't work.
	#LoadAllSaves(_saveMenuManager.loadedSaveList)
	await get_tree().create_timer(1).timeout
	AddSaveGameItemObject(_fakeItem)
	AddSaveGameItemObject(_fakeItem)
	AddSaveGameItemObject(_fakeItem)
	AddSaveGameItemObject(_fakeItem)
	AddSaveGameItemObject(_fakeItem)
	AddSaveGameItemObject(_fakeItem)
	AddSaveGameItemObject(_fakeItem)

## Uses a dict to load an object to the loaded save list.
func AddSaveGameItemObject(infoDict: Dictionary[String, Variant]) -> void:
	print("adding")
	var loadedObject: SaveGameItem = _saveGameItemObject.instantiate()
	loadedObject.saveInfoDict = infoDict
	itemContainer.add_child(loadedObject)
	loadedObject.UpdateItemInfo()

## This will load all saves
func LoadAllSaves(savesList: Array[Dictionary]) -> void:
	pass
	# for item in savesList:
	# AddLoadGameItem(item)
