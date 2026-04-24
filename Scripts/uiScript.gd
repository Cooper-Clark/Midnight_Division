extends CanvasLayer

@export var rifleFullMagIcon: Texture = null
@export var rifleHalfMagIcon: Texture = null
@export var rifleEmptyMagIcon: Texture = null

@export var pistolFullMagIcon: Texture = null
@export var pistolHalfMagIcon: Texture = null
@export var pistolEmptyMagIcon: Texture = null

@export var targetingIcon1: Texture = load("res://assets/sprites/crosshairPart1.png")
@export var targetingIcon2: Texture = load("res://assets/sprites/crosshairPart2.png")


@export var uiColour: Color = Color("3d8f41")
@export var uiColourWarning: Color = Color(0.66, 0.616, 0.0, 1.0)
@export var uiColourDanger: Color = Color(0.63, 0.0, 0.0, 1.0)
@export var textTheme: Theme = load("res://assets/AgencyFBTheme.tres")

@export var operatorClassIcons: Array[Texture] = []
@export var enemyClassIcons: Array[Texture] = []

var boxSelecting : bool = false
var boxSelectOrigin : Vector2 = Vector2(0,0)
var clearDraw : bool = true

var groupStandingArray = [
	[Vector2(0,0)],
	[Vector2(-25,0), Vector2(25,0)],
	[Vector2(-25,-25), Vector2(25,-25), Vector2(0,25)],
	[Vector2(-25,-25), Vector2(25,-25), Vector2(-25,25), Vector2(25,25)]
]

var selected : Array[Node] = []
var unitsIdsOnScreen : Array[Node] = []
var mousePositionLast : Vector2 = Vector2(0,0)
var rightDoubleClickTimer : int = 40
var rightDoubleClickTimerC : int = 10

func addOrRemoveNodes(nodeHolder : Node, newAmount : int, nodeToCopy : Node) -> void:
	var diff = nodeHolder.get_children().size() - newAmount
		
	if diff == 0:
		pass
	elif diff < 0:
		for i in range(0,abs(diff)):
				var toAdd = nodeToCopy.duplicate()
				nodeHolder.add_child(toAdd)
	elif diff > 0:
		for i in range(0,diff):
				nodeHolder.get_child(0).queue_free()


func addAlert(string, lifetime) -> void:
	var toAdd = $keeper/alert.duplicate()
	toAdd.text = string
	toAdd.theme = textTheme
	toAdd.visible = true
	#alerts.append( {"id" = toAdd, "lifetime" = lifetime} )
	$alerts.add_child(toAdd)
	toAdd.get_child(0).start()

func updateSelected(units = [], append = false) -> void:
	
	if not append:
		if selected.size() > 0:
				for i in selected:
					if i:
						i.deselect()
		selected.clear()
	
	if units.size() > 0:
		selected.append_array(units)
		for i in units:
			i.select()
	else:
		selected = []

func updateUI() -> void:
	
	#region updateVisibleUnits
	var unitsOnScreen = []
	for i in globals.playerUnitsNode.get_children():
		if Rect2(Vector2(0,0), Vector2(640,360)).has_point(globals.globalToScreenPos(i.position)):
			if i.visibleToPlayer:
				unitsOnScreen.append(i)
	for i in globals.enemyUnitsNode.get_children():
		if Rect2(Vector2(0,0), Vector2(640,360)).has_point(globals.globalToScreenPos(i.position)):
			if i.visibleToPlayer:
				unitsOnScreen.append(i)
	#endregion
	
	#region updateHeardSounds
	
	var visibleHeardSounds = []
	
	for i in globals.soundsHeardByPlayer:
		if Rect2(Vector2(0,0), Vector2(640,360)).has_point(globals.globalToScreenPos(i)):
			visibleHeardSounds.append(i)
	
	
	addOrRemoveNodes($soundsOnScreen , visibleHeardSounds.size() , $keeper/unknownSound)
	
	var iter = 0 
	for i in visibleHeardSounds:
		var icon = $soundsOnScreen.get_child(iter)
		
		icon.position = globals.globalToScreenPos(i) - (icon.size/2)
		
		icon.visible =  true
		iter += 1
	
	#endregion
	
	#region updateUnitIcons
	
	addOrRemoveNodes($unitsOnScreen , unitsOnScreen.size() , $keeper/unitIcon)
	
	unitsIdsOnScreen = []
	iter = 0
	for i in unitsOnScreen:
		unitsIdsOnScreen.append(i)
		var icon = $unitsOnScreen.get_child(iter)
		var tex = icon.get_child(0)
		
		icon.position = globals.globalToScreenPos(i.position) - (icon.size/2)
		
		icon.visible =  true
		tex.texture = i.icon
		tex.position = -tex.texture.get_size()/2
		
		for j in range(1,4):
			icon.get_child(j).visible = false
			if i.selected:
				icon.get_child(j).visible = true
			if j==2:
				icon.get_child(j).rotation = i.lookDir
			if j==3:
				icon.get_child(j).rotation = (i.velocity.angle())
		
		var hoveredControl = get_viewport().gui_get_hovered_control()
		if hoveredControl == tex:
			if Input.is_action_just_pressed("mb_left") == true and i.get_parent() == globals.playerUnitsNode:
				updateSelected([i])
		
		iter += 1
	#endregion
	
	#region makeCrosshairsForAllUnits
	
	var crosshairsToDraw : Array[Node] = []
	for i in globals.playerUnits:
		if i:
			if i.shootingTarget:
				if i.shootingTarget.get_node("onScreen").is_on_screen():
					crosshairsToDraw.append(i)
	
	addOrRemoveNodes($crosshairsOnScreen , crosshairsToDraw.size(), $keeper/crosshair)
	
	iter = 0
	for i in crosshairsToDraw:
		var ch = $crosshairsOnScreen.get_child(iter)
		
		ch.position = globals.globalToScreenPos(i.shootingTarget.global_position) - ch.size/2
		
		for j in range(1,5):
			ch.get_child(j).value = (i.currentAim*100)
			if i.currentAim > 0.7:
				ch.get_child(j).tint_progress = uiColour
			elif i.currentAim < 0.3:
				ch.get_child(j).tint_progress = uiColourDanger
			else:
				ch.get_child(j).tint_progress = uiColourWarning
		
		ch.get_child(5).text = str(int(i.calculateHitChance(i.weapons[i.activeWeapon] , i.shootingTarget)*100), "%")
		
		ch.visible = true
		iter += 1
	#endregion
	
	var hoveredControl = get_viewport().gui_get_hovered_control()
	if not hoveredControl:
		if Input.is_action_just_pressed("mb_left") == true:
			updateSelected([])
	
	if selected.size() > 0:
		if selected[0]:
			$unitElements.visible = true
			
			var anyMagsWithAmmo = false
			for i in $unitElements/mags.get_children():
				i.queue_free()
			for i in selected[0].backpackMags:
				var toAdd = TextureRect.new()
				if i.currentAmmo == i.magSize:
					anyMagsWithAmmo = true
					if i.magIconType == globals.weaponClasses.RIFLE:
						toAdd.texture = rifleFullMagIcon
					if i.magIconType == globals.weaponClasses.PISTOL:
						toAdd.texture = pistolFullMagIcon
					toAdd.modulate = uiColour
				elif i.currentAmmo > 0:
					anyMagsWithAmmo = true
					if i.magIconType == globals.weaponClasses.RIFLE:
						toAdd.texture = rifleHalfMagIcon
					if i.magIconType == globals.weaponClasses.PISTOL:
						toAdd.texture = pistolHalfMagIcon
					toAdd.modulate = uiColourWarning
				else:
					if i.magIconType == globals.weaponClasses.RIFLE:
						toAdd.texture = rifleEmptyMagIcon
					if i.magIconType == globals.weaponClasses.PISTOL:
						toAdd.texture = pistolEmptyMagIcon
					toAdd.modulate = uiColourDanger
				$unitElements/mags.add_child(toAdd)
			
			var showingWeapon = selected[0].weapons[selected[0].activeWeapon]
			if showingWeapon:
				$unitElements/weaponName.text = showingWeapon.displayName
				$unitElements/weaponIconContainer/weaponIcon.texture = showingWeapon.sprite
				
				if showingWeapon.currentMag:
					$unitElements/weaponMagazine.text = str(showingWeapon.currentMag.currentAmmo, "/", showingWeapon.currentMag.magSize)
					$unitElements/weaponMagazine.modulate = uiColour
					if showingWeapon.currentMag.currentAmmo < showingWeapon.currentMag.magSize/2:
						$unitElements/weaponMagazine.modulate = uiColourWarning
					if showingWeapon.currentMag.currentAmmo == 0:
						$unitElements/weaponMagazine.modulate = uiColourDanger
						if anyMagsWithAmmo == false:
							$unitElements/weaponMagazine.text = "No Ammo"
				else:
					if anyMagsWithAmmo == false:
						$unitElements/weaponMagazine.text = "No Ammo"
						$unitElements/weaponMagazine.modulate = uiColourDanger
					else:
						$unitElements/weaponMagazine.text = "Reload"
						$unitElements/weaponMagazine.modulate = uiColourDanger
			
			for i in $unitElements/otherWeapons.get_children():
				i.queue_free()
			
			iter = 0
			for i in selected[0].weapons:
				if iter != selected[0].activeWeapon:
					var toAdd = TextureRect.new()
					toAdd.texture = i.sprite
					$unitElements/otherWeapons.add_child(toAdd)
				iter+=1
	else:
		$unitElements.visible = false
		pass

func _init() -> void:
	#$unitElements.visible = false
	pass

func _process(delta: float) -> void:
	
	#$debug/fps.text = str(Engine.get_frames_per_second(), "/n" , Engine.max_fps)
	#var map = globals.camNode.get_world_2d().navigation_map
	#map = NavigationServer2D.map_get_regions(map)[0]
	
	$debug/fps.text = str(Performance.get_monitor(Performance.TIME_FPS), " 
	" , Performance.get_monitor(Performance.TIME_PROCESS), " 
	")
	#$debug/fps.text = str(globals.soundsHeardByPlayer)
		
	var mPos = globals.screenToGlobalPos($unitElements.get_global_mouse_position())
	
	updateUI()
	
	var alertList = $alerts.get_children()
	if alertList:
		for i in alertList:
			if i.get_child(0).is_stopped():
				i.queue_free()
	
	if Input.is_action_just_pressed("mb_left") == true:
		print("pressed left")
		boxSelectOrigin = $unitElements.get_global_mouse_position()
	
	if Input.is_action_pressed("mb_left") == true:
		if boxSelectOrigin.distance_to($unitElements.get_global_mouse_position()) > 30:
			boxSelecting = true
			clearDraw = false
			var bs = $boxSelect.get_child(0)
			if not (bs):
				var toAdd = ColorRect.new()
				toAdd.name = "boxSelect"
				toAdd.modulate = Color(1.0, 1.0, 1.0, 0.2)
				$boxSelect.add_child(toAdd)
				bs = toAdd
			var bsps = globals.makeRectFromPoints(boxSelectOrigin, $unitElements.get_global_mouse_position())
			bs.position = bsps.position
			bs.size = bsps.size
			
		else:
			boxSelecting = false
			clearDraw = true
	
	if Input.is_action_just_released("mb_left") == true:
		clearDraw = true
		if boxSelecting:
			var inBox = []
			var box = globals.makeRectFromPoints(boxSelectOrigin, $unitElements.get_global_mouse_position())
			var iter = 0
			for i in $unitsOnScreen.get_children():
				if box.intersects(i.get_rect()) and  unitsIdsOnScreen[iter].get_parent() == globals.playerUnitsNode:
					inBox.append(unitsIdsOnScreen[iter])
				iter += 1
			
			updateSelected(inBox)
			var bs = $boxSelect.get_child(0)
			if bs:
				bs.queue_free()
	else:
		clearDraw = false
	
	
	
	if Input.is_action_just_pressed("mb_right") == true:
		print("pressed right")
		var isDoubleClick = (rightDoubleClickTimerC > 1)
		if isDoubleClick:
			print("double pressed right")
		rightDoubleClickTimerC = 1
		
		if selected.size() > 0:
			var move : bool = true
			var hoveredControl : Node = get_viewport().gui_get_hovered_control()
			if hoveredControl != null:
				if hoveredControl.get_parent() == get_node("unitsOnScreen"):
					var unitOfControl = unitsIdsOnScreen[hoveredControl.get_index()]
					if selected.find(unitOfControl):
						move = false
			if move:
				var iter : int = 0
				for i in selected:
					if i:
						i.changeNavPoint(mPos + groupStandingArray[selected.size()-1][iter])
						i.moveOrder = i.moveOrders.MOVETO
						i.timeInMoveOrder = 0
						if isDoubleClick:
							i.moveOrder = i.moveOrders.RUNTO
						i.shootOrder = i.shootOrders.FIREATWILL #ATTEBTUTUION ATTENTION WARNING DANGER DO NOT
						i.timeInShootOrder = 0
					iter += 1
			
		else:
			print("nothing selected!")
	if rightDoubleClickTimerC > 0:
		rightDoubleClickTimerC += 1
		if rightDoubleClickTimerC > rightDoubleClickTimer:
			rightDoubleClickTimerC = 0
	
	if Input.is_action_just_pressed("kb_e") == true:
		if selected.size() > 0:
			var iter : int = 0
			for i in selected:
				if i:
					i.changeNavPoint(i.position)
					i.moveOrder = i.moveOrders.MOVETO
					i.timeInMoveOrder = 0
				iter += 1
	
	if Input.is_action_just_pressed("kb_q") == true:
		if selected.size() > 0:
			var iter : int = 0
			for i in selected:
				if i:
					var cover = i.findCoverFromPoint(mPos, [], true)
					i.changeNavPoint(cover.position)
					i.moveOrder = i.moveOrders.MOVETO
					i.timeInMoveOrder = 0
				iter += 1
	
	if Input.is_action_just_pressed("kb_`") == true:
		addAlert("obliteration", 2)
		for i in globals.enemyUnitsNode.get_children():
			if i:
				i.die()
		
		for i in get_node("/root/game/spawningPools").get_children():
			i.queue_free()
	
	if Input.is_action_pressed("kb_space") == true:
		#if mousePositionLast > 0
		globals.camNode.global_position += (mousePositionLast - get_viewport().get_mouse_position()) / globals.camNode.zoom
	
	if Input.is_action_just_pressed("mb_scrollup") == true:
		#var bing = globals.camNode.zoom
		if globals.camNode.zoom < Vector2(1,1):
			globals.camNode.zoom = globals.camNode.zoom * Vector2(2,2)
	if Input.is_action_just_pressed("mb_scrolldown") == true:
		if globals.camNode.zoom > Vector2(0.0625,0.0625):
			globals.camNode.zoom = globals.camNode.zoom * Vector2(0.5,0.5)
	
	if Input.is_action_just_pressed("kb_r") == true:
		if selected.size() > 0:
			for i in selected:
				if i.weapons[i.activeWeapon]:
					i.reloadWeapon(i.activeWeapon)
	
	if Input.is_action_just_pressed("kb_alt") == true:
		if selected.size() > 0:
			for i in selected:
				if i:
					if i.activeWeapon < i.weapons.size()-1:
						i.changeActiveWeapon(i.activeWeapon+1)
					else:
						i.changeActiveWeapon(0)
	
	mousePositionLast = get_viewport().get_mouse_position()
