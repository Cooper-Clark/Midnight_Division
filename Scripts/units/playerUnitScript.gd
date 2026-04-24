extends unitClass

@export var operatorClass: int = 0
@export var operatorName: String = "Unnamed"

func onReload() -> void:
	globals.hudNode.addAlert(str(operatorName," is reloading"), 4)

func onDeath() -> void:
	globals.hudNode.addAlert(str(operatorName," has died"), 4)

func playerUnitReady() -> void:
	#walkSpeed = 8000.0
	#sprintSpeed = 16000.0
	marksmanship = 0.9
	visibleToPlayer = true
	
	var l = globals.visionsNode.get_child(0).duplicate()
	add_child(l)
	l.visible = true
	l.position = Vector2(0,0)
	
	
	if operatorClass == 1:
		icon = load("res://assets/sprites/unitIcons/technicianIcon.png")
		
		weapons.append(globals.weapon.new( globals.allItems[globals.allItemsEnum.CM85A1] ))
		weapons[0].currentMag = globals.mag.new( globals.allItems[globals.allItemsEnum.CM85_MAG_30RND] )
		weapons[0].currentMag.currentAmmo = weapons[0].currentMag.magSize
		
		weapons.append(globals.weapon.new( globals.allItems[globals.allItemsEnum.XCM19] ))
		weapons[1].currentMag = globals.mag.new( globals.allItems[globals.allItemsEnum.CM19_MAG_18RND] )
		weapons[1].currentMag.currentAmmo = weapons[1].currentMag.magSize
		
		backpackMags = [
			globals.mag.new( globals.allItems[globals.allItemsEnum.CM85_MAG_20RND] ),
			globals.mag.new( globals.allItems[globals.allItemsEnum.CM85_MAG_20RND] ),
			globals.mag.new( globals.allItems[globals.allItemsEnum.CM85_MAG_20RND] ),
			globals.mag.new( globals.allItems[globals.allItemsEnum.CM85_MAG_20RND] ),
			globals.mag.new( globals.allItems[globals.allItemsEnum.CM85_MAG_20RND] ),
			globals.mag.new( globals.allItems[globals.allItemsEnum.CM85_MAG_20RND] ),
			
			globals.mag.new( globals.allItems[globals.allItemsEnum.CM19_MAG_18RND] ),
			globals.mag.new( globals.allItems[globals.allItemsEnum.CM19_MAG_18RND] ),
		]
	
	if operatorClass == 0:
		icon = load("res://assets/sprites/unitIcons/breacherIcon.png")
		
		weapons.append(globals.weapon.new( globals.allItems[globals.allItemsEnum.CM85A1] ))
		weapons[0].currentMag = globals.mag.new( globals.allItems[globals.allItemsEnum.CM85_MAG_30RND] )
		weapons[0].currentMag.currentAmmo = weapons[0].currentMag.magSize
		
		weapons.append(globals.weapon.new( globals.allItems[globals.allItemsEnum.XCM19] ))
		weapons[1].currentMag = globals.mag.new( globals.allItems[globals.allItemsEnum.CM19_MAG_18RND] )
		weapons[1].currentMag.currentAmmo = weapons[1].currentMag.magSize
		
		backpackMags = [
			globals.mag.new( globals.allItems[globals.allItemsEnum.CM85_MAG_20RND] ),
			globals.mag.new( globals.allItems[globals.allItemsEnum.CM85_MAG_20RND] ),
			globals.mag.new( globals.allItems[globals.allItemsEnum.CM85_MAG_20RND] ),
			globals.mag.new( globals.allItems[globals.allItemsEnum.CM85_MAG_20RND] ),
			globals.mag.new( globals.allItems[globals.allItemsEnum.CM85_MAG_20RND] ),
			globals.mag.new( globals.allItems[globals.allItemsEnum.CM85_MAG_20RND] ),
			
			globals.mag.new( globals.allItems[globals.allItemsEnum.CM19_MAG_18RND] ),
			globals.mag.new( globals.allItems[globals.allItemsEnum.CM19_MAG_18RND] ),
		]
	
	if operatorClass == 3:
		icon = load("res://assets/sprites/unitIcons/reconIcon.png")
		
		weapons.append(globals.weapon.new( globals.allItems[globals.allItemsEnum.MUSKET] ))
		weapons[0].currentMag = globals.mag.new( globals.allItems[globals.allItemsEnum.MUSKETBALL] )
		weapons[0].currentMag.currentAmmo = weapons[0].currentMag.magSize
	
		backpackMags = [
			globals.mag.new( globals.allItems[globals.allItemsEnum.MUSKETBALL] ),
			globals.mag.new( globals.allItems[globals.allItemsEnum.MUSKETBALL] ),
			
			globals.mag.new( globals.allItems[globals.allItemsEnum.MUSKETBALL] ),
			globals.mag.new( globals.allItems[globals.allItemsEnum.MUSKETBALL] ),
		]
	
	if operatorClass == 2:
		icon = load("res://assets/sprites/unitIcons/supportIcon.png")
		
		weapons.append(globals.weapon.new( globals.allItems[globals.allItemsEnum.CM260L] ))
		weapons[0].currentMag = globals.mag.new( globals.allItems[globals.allItemsEnum.BELT_EIGHTPOINTFIVE] )
		weapons[0].currentMag.currentAmmo = weapons[0].currentMag.magSize
		
		weapons.append(globals.weapon.new( globals.allItems[globals.allItemsEnum.XCM19] ))
		weapons[1].currentMag = globals.mag.new( globals.allItems[globals.allItemsEnum.CM19_MAG_18RND] )
		weapons[1].currentMag.currentAmmo = weapons[1].currentMag.magSize
		
		backpackMags = [
			globals.mag.new( globals.allItems[globals.allItemsEnum.BELT_EIGHTPOINTFIVE] ),
			globals.mag.new( globals.allItems[globals.allItemsEnum.BELT_EIGHTPOINTFIVE] ),
			
			globals.mag.new( globals.allItems[globals.allItemsEnum.CM19_MAG_18RND] ),
			globals.mag.new( globals.allItems[globals.allItemsEnum.CM19_MAG_18RND] ),
		]
		
	for i in range(0,backpackMags.size()):
		backpackMags[i].currentAmmo = backpackMags[i].magSize
	
	changeActiveWeapon(0)
	pass
	
func playerUnitProcess() -> void:
	#print(seenHostiles)
	pass
	
func _ready() -> void:
	playerUnitReady()
	unitReady()

func _process(delta) -> void:
	playerUnitProcess()
	unitProcess()
