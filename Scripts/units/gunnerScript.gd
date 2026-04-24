extends enemyClass

func gunnerReady() -> void:
	weapons.append(globals.weapon.new( globals.allItems[globals.allItemsEnum.MUSKET] ))
	weapons[0].currentMag = globals.mag.new( globals.allItems[globals.allItemsEnum.MUSKETBALL] )
	weapons[0].currentMag.currentAmmo = weapons[0].currentMag.magSize

func _ready() -> void:
	unitReady()
	enemyUnitReady()
	gunnerReady()
	
func _process(_delta) -> void:
	unitProcess()
	enemyUnitProcess()
