extends unitClass
class_name enemyClass

var thisColliderRID = null
#var recheckLoSTimerCurrent = 5
#var recheckLoSTimer = 5
var timeToStandAroundFor : int = 0

enum behaviorStates {WANDER, RUSH}

var behaviorState = behaviorStates.WANDER

enum enemyUnitClasses {
	MAULER,
	GUNNER
}

var enemyUnitClass : int = 0

func stateWander() -> void:
	if moveOrder == moveOrders.IDLE and timeInMoveOrder > timeToStandAroundFor:
		timeToStandAroundFor = randi_range(4,10)
		moveOrder = moveOrders.MOVETO
		timeInMoveOrder = 0
		Goal = Vector2(randi_range(50,7950),randi_range(50,7950))
		#Goal = Vector2(2000,2000)
		changeNavPoint(Goal)
	if seenHostiles.size() > 0:
		behaviorState = behaviorStates.RUSH
	if heardHostiles.size() > 0:
		if heardHostiles[0]:
			timeToStandAroundFor = randi_range(4,10)
			moveOrder = moveOrders.RUNTO
			timeInMoveOrder = 0
			Goal = heardHostiles[0].position
			#Goal = Vector2(2000,2000)
			changeNavPoint(Goal)

func stateRush() -> void:
	if seenHostiles.size() > 0:
		seenHostiles.sort_custom(sortByDistanceFromUnit)
		moveOrder = moveOrders.CHARGE
		changeNavPoint(seenHostiles[0].position)
	else:
		behaviorState = behaviorStates.WANDER
		timeToStandAroundFor = randi_range(4,10)
		moveOrder = moveOrders.RUNTO
		timeInMoveOrder = 0

func enemyUnitReady() -> void:
	#walkSpeed = 8000.0
	#sprintSpeed = 16000.0
	bloodModulate = Color(0.0, 0.0, 0.0, 1.0)
	thisColliderRID = get_node("colShape")
	
	icon = load("res://assets/sprites/unitIcons/EZMauler.png")
	
func enemyUnitProcess() -> void:
	if behaviorState == behaviorStates.WANDER:
		stateWander()
	elif behaviorState == behaviorStates.RUSH:
		stateRush()

func _ready() -> void:
	unitReady()
	enemyUnitReady()
	
func _process(_delta) -> void:
	unitProcess()
	enemyUnitProcess()

#func _draw() -> void:
	#for i in seenHostiles:
		#draw_line(Vector2(0,0), i.position - position, Color())
