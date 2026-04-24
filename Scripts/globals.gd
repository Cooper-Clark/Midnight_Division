extends Node

@onready var playerUnits : Array[Node] = []#get_node("units/playerUnits").find_children("*", "", false, false)
@onready var enemyUnits : Array[Node] = []
@onready var playerUnitsNode : Node = get_node("../game/units/playerUnits")
@onready var enemyUnitsNode : Node = get_node("../game/units/enemyUnits")
@onready var hudNode : Node = get_node("../game/hud")
@onready var camNode : Node = get_node("../game/cam")
@onready var tempParticlesNode : Node = get_node("../game/tempParticles")
@onready var visionsNode : Node = get_node("../game/visions")
@onready var coversNode : Node = get_node("../game/mapPoints/coverPoints")
@onready var theNavRegion : RID = RID()
var recalcTimerCurrent : int = 10
var recalcTimer : int = 10

var soundsHeardByPlayer : Array[Vector2] = []
var mustMakeCoverPoints : bool = true

var soundRCTimerCurrent : int = 30
var soundRCTimer : int = 60

var runCalculations : bool = true

const pixelsInMetre : int = 2

#region enums

enum operatorClasses {
	BREACHER,
	SUPPORT,
	TECHNICIAN,
	RECON
}

enum weaponClasses {
	PISTOL,
	SMG,
	CARBINE,
	RIFLE,
	SHOTGUN,
	MACHINEGUN,
	LAUNCHER,
	SNIPER,
}

enum itemClasses {
	WEAPON,
	MAGAZINE,
	ROUND
}

enum magTypes {
	CM85,
	CM19,
	BELT_EIGHTPOINTFIVE,
	
	MUSKETBALL,
}

enum allItemsEnum {
	CM85A1,
	CM260L,
	XCM19,
	MUSKET,
	MUSKETBALL,
	CM19_MAG_18RND,
	CM85_MAG_20RND,
	CM85_MAG_30RND,
	BELT_EIGHTPOINTFIVE
}

#endregion

var allItems = {
	allItemsEnum.CM85A1: 
	weaponParams.new(itemParams.new(allItemsEnum.CM85A1, "Arc Tac CM85A1 IAR", load("res://assets/sprites/CM85A1 Sprite.png")) ,
	weaponClasses.RIFLE ,
	[2000,8000] ,
	18 ,
	0.25 ,
	1.0 ,
	2 ,
	[] ,
	magTypes.CM85 ,
	load("res://sounds/heavyrifleshot.wav")) ,
	
	allItemsEnum.CM260L: 
	weaponParams.new(itemParams.new(allItemsEnum.CM260L, "Arc Tac CM260-L GPMG", load("res://assets/sprites/CM60-L Sprite.png")) ,
	weaponClasses.MACHINEGUN ,
	[2000,12000] ,
	15 ,
	0.1 ,
	0.6 ,
	5 ,
	[] ,
	magTypes.BELT_EIGHTPOINTFIVE ,
	load("res://sounds/autorifleshot.wav")) ,
	
	allItemsEnum.XCM19: 
	weaponParams.new(itemParams.new(allItemsEnum.XCM19, "Arc Tac XCM19", load("res://assets/sprites/XCM19 Sprite.png")) ,
	weaponClasses.PISTOL ,
	[500,1500] ,
	30 ,
	0.6 ,
	2.0 ,
	2 ,
	[] ,
	magTypes.CM19 ,
	load("res://sounds/autorifleshot.wav")) ,
	
	allItemsEnum.MUSKET: 
	weaponParams.new(itemParams.new(allItemsEnum.MUSKET, "Musket", load("res://assets/sprites/musketSprite.png")) ,
	weaponClasses.RIFLE ,
	[800,3000] ,
	100 ,
	0.8 ,
	0.8 ,
	12 ,
	[] ,
	magTypes.MUSKETBALL ,
	load("res://sounds/autorifleshot.wav")) ,
	
	allItemsEnum.MUSKETBALL: 
	magParams.new(itemParams.new(allItemsEnum.CM85_MAG_20RND, "Round Shot", null) ,
	1 ,
	1 ,
	magTypes.MUSKETBALL ,
	weaponClasses.RIFLE ) ,
	
	allItemsEnum.CM85_MAG_20RND: 
	magParams.new(itemParams.new(allItemsEnum.CM85_MAG_20RND, "Arc Tac CM85 20 Round Magazine", null) ,
	20 ,
	1 ,
	magTypes.CM85 ,
	weaponClasses.RIFLE ) ,
	
	allItemsEnum.CM85_MAG_30RND: 
	magParams.new(itemParams.new(allItemsEnum.CM85_MAG_30RND, "Arc Tac CM85 30 Round Magazine", null) ,
	30 ,
	1.5 ,
	magTypes.CM85 ,
	weaponClasses.RIFLE) ,
	
	allItemsEnum.CM19_MAG_18RND: 
	magParams.new(itemParams.new(allItemsEnum.CM19_MAG_18RND, "Arc Tac XCM19 18 Round Magazine", null) ,
	18 ,
	1 ,
	magTypes.CM19 ,
	weaponClasses.PISTOL) ,
	
	allItemsEnum.BELT_EIGHTPOINTFIVE: 
	magParams.new(itemParams.new(allItemsEnum.BELT_EIGHTPOINTFIVE, "8.5x59mm Disintegrating Belt", null) ,
	200 ,
	1 ,
	magTypes.BELT_EIGHTPOINTFIVE ,
	weaponClasses.RIFLE) ,
}

#region item class declarations

class item:
	extends Node
	
	var id = null
	var displayName = null
	var sprite = null
	
	func _init(itemArgs) -> void:
		id = itemArgs.id
		displayName = itemArgs.displayName
		sprite = itemArgs.sprite

class itemParams:
	var id;
	var displayName;
	var sprite;
	
	func _init(idA, displayNameA, spriteA) -> void:
		id = idA
		displayName = displayNameA
		sprite = spriteA

class mag:
	extends item
	
	var magSize = 0
	var handling = 1
	var magType = 0
	var magIconType = 0
	var currentAmmo = 0
	
	func _init(magArgs) -> void:
		id = magArgs.id
		displayName = magArgs.displayName
		sprite = magArgs.sprite
		
		magSize = magArgs.magSize
		handling = magArgs.handling
		magType = magArgs.magType
		magIconType = magArgs.magIconType
		currentAmmo = magArgs.currentAmmo

class magParams:
	extends itemParams
	
	var magSize;
	var handling;
	var magType;
	var magIconType;
	var currentAmmo;
	
	func _init(itemArgs, magSizeA, handlingA, magTypeA, magIconTypeA, currentAmmoA = 0):
		id = itemArgs.id
		displayName = itemArgs.displayName
		sprite = itemArgs.sprite
		
		magSize = magSizeA
		handling = handlingA
		magType = magTypeA
		magIconType = magIconTypeA
		currentAmmo = currentAmmoA

class weapon:
	extends item
	
	var attachments = {}
	var weaponClass = null
	var effectiveRange = null
	var fireRate = null
	var recoil = null
	var handling = null
	var reloadTime = null
	var attachmentSlots = null
	var magazineType = null
	var shootSound = null
	
	var currentMag = null
	
	func _init(weaponArgs) -> void:
		id = weaponArgs.id
		displayName = weaponArgs.displayName
		sprite = weaponArgs.sprite
		
		weaponClass = weaponArgs.weaponClass
		effectiveRange = weaponArgs.effectiveRange
		fireRate = weaponArgs.fireRate
		recoil = weaponArgs.recoil
		handling = weaponArgs.handling
		reloadTime = weaponArgs.reloadTime
		attachmentSlots = weaponArgs.attachmentSlots
		magazineType = weaponArgs.magazineType
		shootSound = weaponArgs.shootSound
		
		currentMag = null

class weaponParams:
	extends itemParams
	
	var weaponClass = null
	var effectiveRange = null
	var fireRate = null
	var recoil = null
	var handling = null
	var reloadTime = null
	var attachmentSlots = null
	var magazineType = null
	var shootSound = null
	
	func _init(itemArgs, weaponClassA, effectiveRangeA, fireRateA, recoilA, handlingA, reloadTimeA, attachmentSlotsA, magazineTypeA, shootSoundA):
		id = itemArgs.id
		displayName = itemArgs.displayName
		sprite = itemArgs.sprite
		
		weaponClass = weaponClassA
		effectiveRange = effectiveRangeA
		fireRate = fireRateA
		recoil = recoilA
		handling = handlingA
		reloadTime = reloadTimeA
		attachmentSlots = attachmentSlotsA
		magazineType = magazineTypeA
		shootSound = shootSoundA

#endregion

#region global methods

func pixelsToMetres(pixels) -> float:
	return pixels

func makeRectFromPoints(p1, p2) -> Rect2:
	var w = p2.x - p1.x
	var h = p2.y - p1.y
	if p1.x > p2.x:
		w = p1.x - p2.x
		p1.x = p2.x
		p2.x = p1.x + w
	if p1.y > p2.y:
		h = p1.y - p2.y
		p1.y = p2.y
		p2.y = p1.y + h
	return Rect2(p1.x, p1.y, w, h)

func globalToScreenPos(gPos) -> Vector2:
	var sPos = null
	var cam  = camNode
	var viewportSize = get_viewport().get_visible_rect().size / 2
	sPos = (gPos - cam.position)*cam.zoom + viewportSize
	#sPos - viewportSize = (gPos - cam.position)*cam.zoom
	#(sPos - viewportSize)/cam.zoom = (gPos - cam.position)
	#(sPos - viewportSize)/cam.zoom + cam.position = gPos

	return sPos

func screenToGlobalPos(sPos) -> Vector2:
	var gPos = null
	var cam = camNode
	var viewportSize = get_viewport().get_visible_rect().size / 2
	gPos = (sPos - viewportSize)/cam.zoom + cam.position
	
	return gPos

func canSeePoint(from, to, space) -> bool:

	var params = PhysicsRayQueryParameters2D.new()

	params.from = from
	params.to = to
	params.collision_mask = 0b00000000_00000000_00000000_00000001
	
	var returned = space.intersect_ray(params)
	if returned:
		return false
	return true

func isPointOnNavMesh(point) -> bool:
	var navMeshPoint = (NavigationServer2D.region_get_closest_point(theNavRegion, point))
	return (navMeshPoint.distance_squared_to(point) < 20)

#endregion

func _ready() -> void:
	pass

func _process(delta) -> void:
	if runCalculations:
		if soundRCTimerCurrent == 0:
			soundRCTimerCurrent = soundRCTimer
			unitSoundCheck()
		soundRCTimerCurrent -= 1
		
		if mustMakeCoverPoints:
			if camNode:
				var map = camNode.get_world_2d().navigation_map
				var maoa = NavigationServer2D.map_get_regions(map)
				if maoa.size() > 0:
					theNavRegion = maoa[0]
					generateMapPoints(get_node("../game/mapPoints/coverPoints"))
					mustMakeCoverPoints = false



func _physics_process(_delta) -> void:
	if runCalculations:
		if recalcTimerCurrent == 0:
			recalcTimerCurrent = recalcTimer
			
			unitLoSCheck()
			#unitSoundCheck()
			
			if tempParticlesNode:
				var particles = tempParticlesNode.get_children()
				for i in particles:
					if i.emitting == false:
						i.queue_free()
		recalcTimerCurrent -= 1

func generateMapPoints(allCoverContainer : Node) -> void:
	var allCover : Array[RectangleShape2D] = []
	var marker : Node2D = Node2D.new()
	
	#var navMesh := get_node("../game/navMesh")
	#var navMeshRID = navMesh.get_world_2d().navigation_map
	#var navMeshRID = navMesh.get_world_2d().navigation_map
	
	for i in get_node("../game/navMesh/Walls").find_children("c", "", true):

		var corners : Array[Vector2] = [Vector2(1,1) , Vector2(-1,1) , Vector2(-1,-1) , Vector2(1,-1)]
		var realCorners : Array[Vector2] = []
		var coverPoints = []
		
		#var iXLen : float = i.global_scale.x
		#var iYLen : float = i.global_scale.y
		#var fd = [Vector2(1,0) , Vector2(0,1) , Vector2(-1,0) , Vector2(0,-1)]
		
		for j in corners:
			realCorners.append( i.global_position - (((Vector2((i.global_scale.x/2)*20, (i.global_scale.y/2)*20))*j + j*14) ).rotated(i.global_rotation) )
		
		for j in range(0, realCorners.size()):
			var thisCorner : Vector2 = realCorners[j]
			var nextCorner : Vector2 = Vector2(0,0)
			if j < 3:
				nextCorner = realCorners[j+1]
			else:
				nextCorner = realCorners[0]
			var angToNextCorner = (nextCorner-thisCorner).normalized()
			
			if thisCorner.distance_squared_to(nextCorner) < 50**2:
				var toAppend = [(thisCorner+nextCorner)/2, thisCorner, nextCorner]
				coverPoints.append(toAppend)
			else:
				var toAppend = [thisCorner + angToNextCorner*22, thisCorner]
				coverPoints.append(toAppend)
				
				toAppend = [nextCorner - angToNextCorner*22, nextCorner]
				coverPoints.append(toAppend)

		for j in coverPoints:
			
			#var navMeshPoint = (NavigationServer2D.region_get_closest_point(theNavRegion, j[0]))
			
			#if (navMeshPoint.distance_squared_to(j[0]) < 20):
			if isPointOnNavMesh(j[0]):
				var newMarker : Node = marker.duplicate()
				newMarker.global_position = j[0]
				newMarker.set_script(load("res://scripts/drawDotAtOrigin.gd"))
				allCoverContainer.add_child(newMarker)
				for l in range(1,j.size()):
					if isPointOnNavMesh(j[l]):
						var newChild : Node = marker.duplicate()
						newMarker.add_child(newChild)
						newChild.global_position = j[l]

func unitLoSCheck() -> void:
	if playerUnitsNode:
		playerUnits = playerUnitsNode.find_children("*", "", false, false)

	if enemyUnitsNode:
		enemyUnits = enemyUnitsNode.find_children("*", "", false, false)

	#var enemyList = get_node("units/enemyUnits").find_children("*", "", false, false)
	if playerUnits and enemyUnits:
		var space = PhysicsServer2D.space_get_direct_state(playerUnits[0].get_world_2d().get_space())
		var firstIter = true
		for i in playerUnits:
			i.seenHostiles = []
			#print(i.position)
			for j in enemyUnits:
				if firstIter:
					j.seenHostiles = []
					j.visibleToPlayer = false
				var params = PhysicsRayQueryParameters2D.new()
				#print("  ",j.position)
				params.from = i.position
				params.to = j.position
					# 1 walls
					# 2 units
				params.collision_mask = 0b00000000_00000000_00000000_00000001
				#params.exclude.append(i.get_rid())
				var returned = space.intersect_ray(params)
				if not returned:
					j.visibleToPlayer = true
					#print("ray cast from " , i , " returned: ", returned)
					i.seenHostiles.append(j)
					j.seenHostiles.append(i)
			firstIter = false
	elif playerUnits:
		for i in playerUnits:
			i.seenHostiles = []
	elif enemyUnits:
		for i in enemyUnits:
			i.seenHostiles = []

func unitSoundCheck() -> void:
	if playerUnitsNode:
		playerUnits = playerUnitsNode.find_children("*", "", false, false)
	if enemyUnitsNode:
		enemyUnits = enemyUnitsNode.find_children("*", "", false, false)
	#var enemyList = get_node("units/enemyUnits").find_children("*", "", false, false)
	
	soundsHeardByPlayer = []
	if playerUnits and enemyUnits:
		#var firstIter = true
		for i in playerUnits:
			i.heardHostiles = []
			for j in enemyUnits:
				if i.position.distance_to(j.position) < j.soundMaking:
					i.heardHostiles.append(j)
					if j.visibleToPlayer == false:
						soundsHeardByPlayer.append(j.position)
		for i in enemyUnits:
			i.heardHostiles = []
			for j in playerUnits:
				if i.position.distance_to(j.position) < j.soundMaking:
					i.heardHostiles.append(j)
					
		for i in enemyUnits:
			i.soundMaking = 0
		for i in playerUnits:
			i.soundMaking = 0
