extends Node2D
class_name playerMastermindClass
#@export var controlledUnits = null
@export var selected = []

#DO NOT MESS WITH THIS SCRIPT YET, NEEDS TO BE MADE MORE READABLE

var boxSelecting = false
var boxSelectOrigin = Vector2(0,0)
var clearDraw = true

var groupStandingArray = [
	[Vector2(0,0)],
	[Vector2(-25,0), Vector2(25,0)],
	[Vector2(-25,-25), Vector2(25,-25), Vector2(0,25)],
	[Vector2(-25,-25), Vector2(25,-25), Vector2(-25,25), Vector2(25,25)]
]

var mousePositionLast = Vector2(0,0)
var rightDoubleClickTimer = 40
var rightDoubleClickTimerC = 10
var playerUnitsNode = null
var enemyUnitsNode = null

func makeRectFromPoints(p1, p2) -> Rect2:
	#var p1unaltered = p1
	#var p2unaltered = p2
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

func unitsInBox(units, rect) -> Array:
	var returned = []
	print(rect)
	for i in units:
		if rect.has_point(i.position):
			returned.append(i)
	
	return returned

func updateSelected(units = [], append = false) -> void:
	
	if not append:
		if selected.size() > 0:
				for i in selected:
					if i:
						i.deselect()
		selected.clear()
	
	if units.size() > 0:
		$hud.selectedUnit = units[0]
		for i in units:
			i.select()
			selected.append(i)
	else:
		$hud.selectedUnit = null
	$hud.updateUI()

func unitsUnderPoint(point = Vector2(0,0), collideAreas = true, collideBodies = true) -> Node:
	var space = PhysicsServer2D.space_get_direct_state(get_world_2d().get_space())
	
	var returned = null


	var params = PhysicsPointQueryParameters2D.new()
	params.collide_with_areas = collideAreas
	params.collide_with_bodies = collideBodies
	returned = space.intersect_point(params, 1)
	
	if returned.size() > 0:
		return returned[0]["collider"].get_parent()
	else:
		return null

func _ready() -> void:
	#get_window().size = Vector2i(640,380)
	playerUnitsNode = get_node("../units/playerUnits")
	enemyUnitsNode = get_node("../units/enemyUnits")
	print( playerUnitsNode )

func _process(delta) -> void:	
	
	var mPos = get_global_mouse_position()
	
	
	if Input.is_action_just_pressed("mb_left") == true and 1==0:
		print("pressed left")
		boxSelectOrigin = mPos
		
		updateSelected([],false)
		
		var unitUnderCursor = unitsUnderPoint(mPos, true, false)
		
		if unitUnderCursor:
			if unitUnderCursor.get_parent() == playerUnitsNode:
				updateSelected([unitUnderCursor], false)
	
	if Input.is_action_pressed("mb_left") == true and 1==0:
		queue_redraw()
		if boxSelectOrigin.distance_to(mPos) > 30:
			boxSelecting = true
			clearDraw = false
		else:
			boxSelecting = false
			clearDraw = true
		
	if Input.is_action_just_released("mb_left") == true and 1==0:
		clearDraw = true
		queue_redraw()
		if boxSelecting:
			var inBox = unitsInBox(globals.playerUnits, makeRectFromPoints(boxSelectOrigin, mPos))
			updateSelected(inBox)
	else:
		clearDraw = false
		
	if Input.is_action_just_pressed("mb_right") == true:
		print("pressed right")
		var isDoubleClick = (rightDoubleClickTimerC > 1)
		if isDoubleClick:
			print("double pressed right")
		rightDoubleClickTimerC = 1
		
		if selected.size() > 0:
			var unitUnderCursor = unitsUnderPoint(mPos, true, false)
			if unitUnderCursor != null:
				var unitAffil = unitUnderCursor.get_parent()
				if unitAffil == enemyUnitsNode:
					for i in selected:
						i.shootingTarget = unitUnderCursor
			else:
				var iter = 0
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
		
	if Input.is_action_pressed("kb_space") == true:
		#if mousePositionLast > 0
		$Camera2D.global_position += (mousePositionLast - get_viewport().get_mouse_position()) / $Camera2D.zoom
		
	if Input.is_action_just_pressed("mb_scrollup") == true:
		$Camera2D.zoom = $Camera2D.zoom * Vector2(2,2)
	if Input.is_action_just_pressed("mb_scrolldown") == true:
		$Camera2D.zoom = $Camera2D.zoom * Vector2(0.5,0.5)
	
	if Input.is_action_just_pressed("kb_r") == true:
		if selected.size() > 0:
			for i in selected:
				if i.weapons[i.activeWeapon]:
					i.reloadWeapon(i.activeWeapon)
	
	if Input.is_action_just_pressed("kb_alt") == true:
		if selected.size() > 0:
			for i in selected:
				if i.activeWeapon < i.weapons.size()-1:
					i.changeActiveWeapon(i.activeWeapon+1)
				else:
					i.changeActiveWeapon(0)
	
	mousePositionLast = get_viewport().get_mouse_position()


func _draw() -> void:
	if !(clearDraw):
		var rect = makeRectFromPoints(boxSelectOrigin-position, get_global_mouse_position()-position)
		draw_rect(rect, Color(1.0, 1.0, 1.0, 0.2), true)

func _on_unit_control_mouse_entered() -> void:
	print("hovering over Unit")
	#get_global_rect()

func _on_unit_control_mouse_exited() -> void:
	print("no longer hovering over Unit")
