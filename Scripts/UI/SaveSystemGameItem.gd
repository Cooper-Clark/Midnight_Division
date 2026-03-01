extends Node
## Parent of [LoadGameItem] & [SaveGameItem], an UI element used to save or load progress
class_name SaveSystemGameItem

@onready var saveNameLabel: Label = $Panel/VBoxContainer/SaveNameLabel
@onready var dateLabel: Label = $Panel/VBoxContainer/DateLabel
@onready var versionLabel: Label = $Panel/VBoxContainer/VersionLabel
@onready var infoLabel: Label = $Panel/VBoxContainer/InfoLabel

## This alongside [Global]'s tempLevelInfoDict & tempGameInfoDict. For Save and Loading
var saveInfoDict: Dictionary[String, Variant] = {
	"Name": "Name", # Placeholder, but is important
	"Date": "01/01/01", # Placeholder, Check https://docs.godotengine.org/en/stable/classes/class_time.html
	"Version": "0.01", # Placeholder, but is important
	"SomeInfo": 1 # Placeholder, not important will be replaced by relevant information
}

func UpdateItemInfo() -> void:
	saveNameLabel.text = saveInfoDict["Name"]
	dateLabel.text = saveInfoDict["Date"]
	versionLabel.text = saveInfoDict["Version"]
	infoLabel.text = str(saveInfoDict["SomeInfo"]) # str will convert the integer into a string
