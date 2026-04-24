extends Node

## This is a temporary holder information for when we eventually save or we load into with overall campaign
var tempGameInfoDict: Dictionary[String, Variant] = {
	"Name": "Name", ## Placeholder, but is important
	"Date": 1235234, ## Placeholder, Check https://docs.godotengine.org/en/stable/classes/class_time.html, float: Unix Time
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
		Time.get_unix_time_from_system()

## This was brought over from another godot game, This will be fitted to work with this game
#func CheckSettingsVersion() -> bool:
	#if (SettingsDict.find_key("SettingsVersion") != ""):
		#print("Check Settings Version")
		#if (SettingsDict.SettingsVersion != gameSaveVersion):
			#push_error("Incompatible Settings Version, Current is " + str(gameSaveVersion) + ", Your Version is " + str(SettingsDict.SettingsVersion))
			#await ResetSettings()
			#VersionChecked.emit()
			#return false
		#else:
			#print("Correct Settings Version")
			#await get_tree().create_timer(0.001).timeout
			#VersionChecked.emit()
			#return true
	#else:
		#push_error("The Key SettingsVersion doesn't exist")
		#SettingsDict.SettingsVersion = gameSaveVersion
		#ResetSettings()
		#SaveSettings()
		#print("Settings Version: " + SettingsDict.SettingsVersion)
		#await get_tree().create_timer(0.001).timeout
		#VersionChecked.emit()
		#return false
