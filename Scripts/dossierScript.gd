extends Node

var knightStats = {
	"nellie" : {
		"name" : "Nellie",
		"sprite" : load("res://assets/sprites/NellieCrunched.png"),
		"statistics": 
		{
			"nerve" : 60,
			"marksmanship" : 65,
			"cqc" : 100,
			"strength" : 55
		},
		"knownSpells":
		[
			{"name": "Destroy Spawning Pool"},
			{"name": "Summon Ammunition"},
			{"name": "Chain Lightning"}
		],
		"info": 
		{
			"signetWeapon" : 
				{
					"name" : "Nuclear Options",
					"sprite" : load("res://assets/sprites/NuclearOptionsSprite.png")
				},
			"signetRune" :
				{
					"name" : "Doomsday",
					"desc" : "Anderson can summon an infinite amount of her signet weapon and remotely detonate them as explosives at will."
				},
			"bio" :
				"Legal Name: Eleanor Anderson
Sex: Female
Hair: Red
Eyes: Blue
Date of Birth: November 21st, 2014 
Place of Birth: Augusta, Maine"
		},
		"abilities":
		[
			{"name": "Spellcaster"},
			{"name": "Signet Rune - Doomsday"}
		],
		"gear":
		[
			{"name": "'Thermopylae' Plate Carrier"},
			{"name": "Pistol Holster"}
		],
	},
	
	"otto" : {
		"name" : "Otto",
		"sprite" : load("res://assets/sprites/ottoCrunched.png"),
		"statistics": 
		{
			"nerve" : 70,
			"marksmanship" : 75,
			"cqc" : 70,
			"strength" : 90
		},
		"knownSpells":
		[
			{"name": "Destroy Spawning Pool"},
			{"name": "Summon Ammunition"},
			{"name": "Materialize Cover"}
		],
		"info": 
		{
			"signetWeapon" : 
				{
					"name" : "The Crew",
					"sprite" : load("res://assets/sprites/theCrewSprite.png")
				},
			"signetRune" :
				{
					"name" : "One-Man-Army",
					"desc" : "Otto manifests spectral arms extending from his back, each strong enough to wield heavy firearms independently. The only limitation is physical strain as his back bears the full burden, resulting in chronic pain and a hard limit on the weight he can carry."
				},
			"bio" :
				"Legal Name: Otto Alexander-Roberts
Sex: Male
Hair: Black
Eyes: Brown
Date of Birth: January 3rd, 2016 (Age 24)
Place of Birth: New York City, New York"
		},
		"abilities":
		[
			{"name": "Spellcaster"},
			{"name": "Signet Rune - One-Man-Army"}
		],
		"gear":
		[
			{"name": "'Thermopylae' Plate Carrier"},
			{"name": "Mechanism"}
		],
	},
	
	"kim" : {
		"name" : "'Chaplain'",
		"sprite" : load("res://icon.svg"),
		"statistics": 
		{
			"nerve" : 95,
			"marksmanship" : 100,
			"cqc" : 65,
			"strength" : 45
		},
		"knownSpells":
		[
			{"name": "Destroy Spawning Pool"},
			{"name": "Summon Ammunition"},
			{"name": "Smoke Screen"}
		],
		"info": 
		{
			"signetWeapon" : 
				{
					"name" : "Miserichordia",
					"sprite" : load("res://assets/sprites/MiserichordiaSprite.png")
				},
			"signetRune" :
				{
					"name" : "Fell Assassin",
					"desc" : "Sinclain can summon ammunition for her signet weapon with magical properties such as ricocheting off any non-organic material or piercing through any non-organic material as if it did not exist."
				},
			"bio" :
				"Legal Name: Kim Sinclair
Sex: Female
Hair: Black
Eyes: Brown
Date of Birth: August 7th, 2020 (Age 19)
Place of Birth: Ho Chi Minh City, Vietnam"
		},
		"abilities":
		[
			{"name": "Spellcaster"},
			{"name": "Signet Rune - Fell Assassin"}
		],
		"gear":
		[
			{"name": "Rangefinder"},
			{"name": "PDW"},
		],
	},
	
	"vince" : {
		"name" : "Vince",
		"sprite" : load("res://icon.svg"),
		"statistics": 
		{
			"nerve" : 85,
			"marksmanship" : 55,
			"cqc" : 100,
			"strength" : 85
		},
		"knownSpells":
		[
			{"name": "Destroy Spawning Pool"},
			{"name": "Summon Ammunition"},
			{"name": "Smoke Screen"}
		],
		"info": 
		{
			"signetWeapon" : 
				{
					"name" : "Speak Softly",
					"sprite" : load("res://assets/sprites/speakSoftlySprite.png")
				},
			"signetRune" :
				{
					"name" : "Meltdown",
					"desc" : "Vince can make lava course through his veins, causing him to radiate heat and melt Echo Zulu around him."
				},
			"bio" :
				"Legal Name: Vincent Martin
Sex: Male
Hair: Blonde
Eyes: Blue
Date of Birth: January 2nd, 2014 (Age 26)
Place of Birth: Boise, Idaho"
		},
		"abilities":
		[
			{"name": "Spellcaster"},
			{"name": "Signet Rune - Meltdown"}
		],
		"gear":
		[
			{"name": "S&W .500"},
		],
	},
	
	"penni" : {
		"name" : "Penni",
		"sprite" : load("res://icon.svg"),
		"statistics": 
		{
			"nerve" : 90,
			"marksmanship" : 70,
			"cqc" : 100,
			"strength" : 40
		},
		"knownSpells":
		[
			{"name": "Destroy Spawning Pool"},
			{"name": "Summon Ammunition"},
			{"name": "Fireball"}
		],
		"info": 
		{
			"signetWeapon" : 
				{
					"name" : "K.I.S.S",
					"sprite" : load("res://icon.svg")
				},
			"signetRune" :
				{
					"name" : "Crane",
					"desc" : "Penni can summon a spectral crane in the sky that attaches to her mech suit, allowing her to swing around at high speeds."
				},
			"bio" :
				"Legal Name: Penelope King
Sex: Female
Hair: Black
Eyes: Brown
Date of Birth: June 28th, 2011 (Age 28)
Place of Birth: Atlanta, Georgia
"
		},
		"abilities":
		[
			{"name": "Spellcaster"},
			{"name": "Signet Rune - Crane"}
		],
		"gear":
		[
			{"name": "'Thermopylae' Plate Carrier"},
			{"name": "PDW"},
		],
	},
}

var knights = [
	"nellie",
	"otto",
	"kim",
	"vince",
	"penni"
]

var currentKnight = 0



func loadCharacter(characterID : String) -> void:
	var cI = knightStats[characterID]
	var ui = $panel/margin/menu
	var listItem = $keeper/listItem
	
	ui.get_node("middleCont/unitName").text = cI["name"]
	ui.get_node("middleCont/unitSprite").texture = cI["sprite"]
	
	for i in ["nerve", "marksmanship", "cqc", "strength"]:
		ui.get_node( str("stats/characteristics/", i, "/value")).text = str(cI["statistics"][i])
		ui.get_node(str("stats/characteristics/", i, "Bar")).value = cI["statistics"][i]
	
	for i in ui.get_node("stats/spells").get_children():
		i.queue_free()
	for i in cI["knownSpells"]:
		var dsa = listItem.duplicate()
		ui.get_node("stats/spells").add_child(dsa)
		dsa.get_child(1).text = str( i["name"] )

	ui.get_node("rightBar/infoScroll/info/signetWeaponInfo/value").text = str( "'", cI["info"]["signetWeapon"]["name"], "'" )
	ui.get_node("rightBar/infoScroll/info/signetWeaponInfo/sprite").texture = cI["info"]["signetWeapon"]["sprite"]

	ui.get_node("rightBar/infoScroll/info/signetRuneInfo/label").text = str( "Signet Rune - ", cI["info"]["signetRune"]["name"] )
	ui.get_node("rightBar/infoScroll/info/signetRuneInfo/value").text = cI["info"]["signetRune"]["desc"]
	
	ui.get_node("rightBar/infoScroll/info/bio/value").text = cI["info"]["bio"]
	
	
	for i in ui.get_node("rightBar/abilitiesScroll/abilities/abilitiesList").get_children():
		i.queue_free()
	for i in cI["abilities"]:
		var dsa = listItem.duplicate()
		ui.get_node("rightBar/abilitiesScroll/abilities/abilitiesList").add_child(dsa)
		dsa.get_child(1).text = str( i["name"] )
	
	
	for i in ui.get_node("rightBar/gearScroll/gear/gearList").get_children():
		i.queue_free()
	for i in cI["gear"]:
		var dsa = listItem.duplicate()
		ui.get_node("rightBar/gearScroll/gear/gearList").add_child(dsa)
		dsa.get_child(1).text = str( i["name"] )

func _ready() -> void:
	loadCharacter("nellie")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("kb_e") == true:
		currentKnight += 1
		if currentKnight >= knights.size():
			currentKnight = 0
		loadCharacter(knights[currentKnight])
