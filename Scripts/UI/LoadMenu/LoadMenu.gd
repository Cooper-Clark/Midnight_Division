extends Node
## This is the menu that contains all loading user interface.
class_name UILoadMenu

var _loadMenuManager: LoadMenuManager
## This is our Object that'll be used to hold save info
var _loadGameItemObject: PackedScene = preload("res://Scenes/Menus/LoadMenu/LoadGameItem.tscn")
@onready var itemContainer: VBoxContainer = $"../LoadMenu/ScrollContainer/ItemContainer"


var _fakeItem: Dictionary[String, Variant] = {
	"Name": "Name", # Placeholder, but is important
	"Date": "01/01/01", # Placeholder, Check https://docs.godotengine.org/en/stable/classes/class_time.html
	"Version": "0.01", # Placeholder, but is important
	
	"SomeInfo": 1 # Placeholder, not important will be replaced by relevant information
}

func _ready() -> void:
	_loadMenuManager = get_node("LoadMenuManager")
	# We don't need this for now as it doesn't work.
	#LoadAllSaves(_loadMenuManager.loadedLoadList)
	await get_tree().create_timer(1).timeout
	AddLoadGameItemObject(_fakeItem)
	AddLoadGameItemObject(_fakeItem)
	AddLoadGameItemObject(_fakeItem)
	AddLoadGameItemObject(_fakeItem)
	AddLoadGameItemObject(_fakeItem)
	AddLoadGameItemObject(_fakeItem)
	AddLoadGameItemObject(_fakeItem)

## Uses a dict to load an object to the loaded save list.
func AddLoadGameItemObject(infoDict: Dictionary[String, Variant]) -> void:
	var loadedObject: LoadGameItem = _loadGameItemObject.instantiate()
	loadedObject.saveInfoDict = infoDict
	itemContainer.add_child(loadedObject)
	loadedObject.UpdateItemInfo()

## This will load all saves
func LoadAllSaves(savesList: Array[Dictionary]) -> void:
	pass
	# for item in savesList:
	# AddLoadGameItem(item)
