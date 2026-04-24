extends CharacterBody2D
class_name unitClass

@export var movement_speed : float = 50.0
@export var walkSpeed : float = 100.0
@export var sprintSpeed : float = 200.0


# STATES
#var orders = [ [0, [] ]

enum moveOrders {STANDGROUND, IDLE, MOVETO, RUNTO, MOVEINTOLOS, CHARGE} #detirmines unit behavior for moving
	# -1 = standGround
	# 0 = idle, don't move unless an enemy gets dangerously close
	# 1 = moveTo, slowly move to an area while still being able to shoot and look around
	# 2 = runTo, move quickly to goal location, locks shoot state into only shooting straight ahead.
	# 3 = moveIntoLoS, moveTo until LoS on Goal
	# 4 charge = bum rush a unit until you are in melee range

enum shootOrders {HOLDFIRE, FIREATWILL, SHOOTAT} #detirmines unit behavior for targeting
	# -1 = holdFireOverride, will not shoot under any circumstances.
	# 0 = holdFire, will not shoot until enemy gets dangerously close.
	# 1 = fireAtWill, will idly look around and listen for sounds, if enemy is spotted, will open fire. Will prioritize closer targets.
	# 2 = shootAt, shoots at ShootingTarget until it leaves LoS. Will switch to fireAtWill if a unit gets dangerously close or unit losesLoS.

enum burstTypes {PRECISION, BURST, FULLAUTO}
var burstType = 1
var bursting = true

enum armsStates {ATEASE, READY, SHOOTING, MELEE, TASK, IMMOBILETASK} #detirmines exactly what this unit is doing right now for animations
	# 0 = ready
	# 1 = shooting
	# 2 = reloading
	# 3 = performing a task

enum tasks {NOTASK, RELOAD}
var taskType : int = 0
var taskDetails = null

enum legsStates {STAND, WALK, RUN, CROUCH, DOWN} #detirmines exactly what this unit is doing right now for animations
	# 0 = standing around
	# 1 = walking
	# 2 = running
	# 3 = injured/down

enum statusesEnum {BLEED}

var	moveOrder : int = moveOrders.IDLE
var timeInMoveOrder : int = 0
var	shootOrder : int = shootOrders.HOLDFIRE
var timeInShootOrder : int = 0

var currentCover : Node = null

var armsState : int = 0
var legsState : int = 0

# stats
@export var blood : int = 100
@export var maxBalance : float = 1
var balance : float = 1
var statuses = []

# functionality vars
var seenHostiles = []
var seenAllies = []

var heardHostiles = []
var soundMaking : int = 0

const walkingSoundDist : int = 300
const runningSoundDist : int = 1500
const gunshotSoundDist : int = 6000

#var underCursor = true
var lookDir : float = 0
var lookSpeed : float = 1.0
var lookDest : float = deg_to_rad(90)
var shootingTarget : Node = null
var dirToNextNavpoint : float = 0

# Weapons Vars
var currentAim : float = 1
var gunRecharge : int = 0
var gunRechargeTime : int = 18
var weapons : Array[Object] = []
var backpackMags : Array[Object] = []
var activeWeapon : int = 0

var marksmanship : float = 0.8


const meleeRange : int = 30
const baseLookSpeed : float = 0.05
const movementSmoothing : float = 2


var selected = false
var visibleToPlayer : bool = false
var Goal : Vector2 = position
var muzzleFlashParticle: PackedScene = load("res://scenes/particles/muzzleFlash.tscn")
var bloodParticle: PackedScene = load("res://scenes/particles/bloodDrops.tscn")
var bloodSplatParticle: PackedScene = load("res://scenes/particles/bloodSplat.tscn")
var deathBloodParticle: PackedScene = load("res://scenes/particles/bloodPool.tscn")
var bloodModulate: Color = Color(0.694, 0.0, 0.0, 1.0)
var runIconTexture: Texture = load("res://assets/sprites/unitIcons/runIcon.png")
var walkIconTexture: Texture = load("res://assets/sprites/unitIcons/walkIcon.png")
var icon: Texture = null

@export var blind: bool = false #unit always considers "seenHostiles" empty
@export var deaf: bool = false #unit always considers "heardHostiles" empty
@export var schizophrenic: bool = false #unit can hear only sounds outside of its normal hearing range


func onReload() -> void:
	pass

func onMelee() -> void:
	pass
	
func onDeath() -> void:
	pass



func cleanSeenHostiles() -> void:
	var clean = []
	for i in seenHostiles:
		if i:
			clean.append(i)
	seenHostiles = clean

func angleInCone(dir, coneDir, coneSize) -> bool:
	var diff = abs(dir-coneDir)
	
	if diff > 180:
		diff = 360-diff
	
	if diff < coneSize:
		return true
	return false

func canSeePoint(pointGlobal) -> bool:
	var space = PhysicsServer2D.space_get_direct_state(get_world_2d().get_space())
	var params = PhysicsRayQueryParameters2D.new()
	#print("  ",j.position)
	params.from = global_position
	params.to = pointGlobal
	#params.exclude.append(i.get_node("colShape"))
	if space.intersect_ray(params)["collider"]:
		return false
	return true

func sortByDistanceFromUnit(a, b):
	if a and b:
		if position.distance_squared_to(a.position) < position.distance_squared_to(b.position):
			return true
	return false

func changeNavPoint(whereTo) -> void:
	#print(whereTo)
	Goal = whereTo
	$unitNavAgent.target_position = whereTo
	#print("Path is ", $unitNavAgent.get_next_path_position())
	#print("Path is ", $unitNavAgent.get_current_navigation_path())
	if not $unitNavAgent.is_target_reachable():
		whereTo = $unitNavAgent.get_final_position()
		$unitNavAgent.target_position = whereTo
		Goal = whereTo
		#print("Goal out of bounds! New goal = ", $unitNavAgent.get_final_position())

func die() -> void:
	emitBloodSplat(0,deathBloodParticle)
	onDeath()
	queue_free()

func takeDamage(damage) -> void:
	blood -= damage
	print(self, " took ", damage , " damage! new blood: ", blood)
	emitBloodSplat(0, bloodParticle)
	if blood < 1:
		die()

func reloadWeapon(weaponInd) -> void:
	if weapons[weaponInd].currentMag:		
		backpackMags.insert(0, weapons[weaponInd].currentMag)
		weapons[weaponInd].currentMag = null
		
		var magToLoad = null;
		#var iter = 0
		for i in backpackMags:
			if i.magType == weapons[weaponInd].magazineType:
				if !(magToLoad):
					magToLoad = i
				elif i.currentAmmo > magToLoad.currentAmmo:
					magToLoad = i
			#iter += 1
		
		if magToLoad:
			$taskTimer.start(weapons[weaponInd].reloadTime)
			taskDetails = {"weaponToLoad": weaponInd , "magToLoad": magToLoad}
			armsState = armsStates.TASK
			taskType = tasks.RELOAD
			
			onReload()

func performRangedAttack(target, weaponInd, hitChance) -> void:
	$unitAudio.stream = weapons[weaponInd].shootSound
	$unitAudio.pitch_scale = randf_range(0.95,1.05)
	$unitAudio.play()
	gunRecharge = weapons[weaponInd].fireRate
	weapons[weaponInd].currentMag.currentAmmo -= 1
	currentAim = clampf(currentAim-weapons[weaponInd].recoil, 0.0, 1.0)
	#globals.pMNode.get_node("hud").updateUI()
	if randf() < hitChance:
		target.takeDamage(30)
		target.statuses.append([statusesEnum.BLEED, 10])
		target.knockBack(global_position.angle_to_point(target.global_position), 200, 0.3)
		target.emitBloodSplat(target.global_position.angle_to_point(global_position), bloodSplatParticle)
	
	soundMaking = max(soundMaking, gunshotSoundDist)
	
	var theFlash = muzzleFlashParticle.instantiate()
	theFlash.global_position = global_position + Vector2(20,0).rotated(lookDir)
	theFlash.rotation = lookDir
	theFlash.emitting = true
	theFlash.one_shot = true
	
	globals.tempParticlesNode.add_child(theFlash)

func meleeAttack(target) -> void:
	
	var targetCanBlock = false
	if (target.balance>0.0 and angleInCone(target.lookDir, target.global_position.angle_to_point(global_position), PI/2)):
		targetCanBlock = true
	
	#var rand : float = randf()
	if not targetCanBlock:
		target.takeDamage(60)
		target.knockBack(global_position.angle_to_point(target.global_position), 400, 0.8)
	else: 
		knockBack(target.global_position.angle_to_point(global_position), 800, 1.0)
		target.knockBack(global_position.angle_to_point(target.global_position), 300, 0.4)

func knockBack(dir, force, balanceDamage) -> void:
	var pushVector = Vector2(cos(dir),sin(dir)) * force
	
	balance = clampf(balance-balanceDamage, 0.0, 1.0)
	
	velocity += pushVector
	
	#move_and_collide()

func moveTowardsPoint(pointLocal : Vector2, deltaTime : float, nextPointLocal : Vector2 = Vector2(0,0))->void:
	
	#var brakingSpeed : float = 120.0
	#var currentSpeed : Vector2 = abs(velocity)
	#var fullStopVector : Vector2 = Vector2(0,0)
	#while currentSpeed > Vector2(0,0):
		#currentSpeed -= currentSpeed.normalized()*(brakingSpeed)
		#fullStopVector += currentSpeed
	
	var desiredVelocity : Vector2 = pointLocal.normalized()*movement_speed  #.limit_length(movement_speed)
	
	if balance > 0.5:
		#if pointLocal.length_squared() <= movement_speed/3:
			#desiredVelocity = Vector2(0,0)
			#velocity += ((desiredVelocity - velocity)).limit_length(20)
		#else:
		velocity += ((desiredVelocity - velocity)).limit_length(movement_speed/10)
		
		if velocity.length_squared() > movement_speed**2:
			velocity = velocity.limit_length(movement_speed)
		
		#if (desiredVelocity.length_squared() > movement_speed**2):
			#desiredVelocity = desiredVelocity.normalized()
			#desiredVelocity *= movement_speed
			#
			#
		#var intermediate : Vector2 = (velocity - velocity.lerp(desiredVelocity, 0.1))
#
		#if (intermediate.length_squared() > movement_speed**2):
			#intermediate = intermediate.normalized()
			#intermediate *= movement_speed
			#
		#velocity += intermediate
		
		if movement_speed == walkSpeed:
			soundMaking = max(soundMaking, walkingSoundDist)
		if movement_speed == sprintSpeed:
			soundMaking = max(soundMaking, runningSoundDist)

func changeActiveWeapon(newWeaponInd)->void:
	activeWeapon = newWeaponInd
	lookSpeed = baseLookSpeed * weapons[activeWeapon].handling

func emitBloodSplat(angleHitFrom, type) -> void:
	var theBlood = type.instantiate()
	theBlood.global_position = global_position
	angleHitFrom = rad_to_deg(angleHitFrom)+180
	theBlood.rotation_degrees = angleHitFrom
	theBlood.one_shot = true
	theBlood.emitting = true
	theBlood.modulate = bloodModulate
	
	globals.tempParticlesNode.add_child(theBlood)
	#theBlood.process_material.angle_min = angleHitFrom

func calculateHitChance(weapon, target) -> float:
	var distSq = global_position.distance_squared_to(target.global_position)
	
	var rangePenalty = 1
	if (distSq > weapon.effectiveRange[1]**2):
		return 0.0
	if (distSq > weapon.effectiveRange[0]**2):
		var percentBetween = (sqrt(distSq)-(weapon.effectiveRange[0])) / ((weapon.effectiveRange[1]-weapon.effectiveRange[0]))
		rangePenalty = 1.0-percentBetween
	return snappedf(marksmanship * rangePenalty * (0.5+currentAim/2), 0.01)

func findCoverFromPoint(pointToSee : Vector2 , hidingFrom = [], shootingBack : bool = false) -> Node:
	# Evaluates all possible cover points based on
	# certain perameters and then returns the ID of the best one
	
	# Parameters
	# pointToSee - the position of the thing this unit is trying to be able to peek.
	# hidingFrom - the units this unit is trying to hide from if there are any.
	# shootingBack - is this unit trying to shoot back?
	
	# Perameters
	# Distance to target
	# Distance from this unit
	# target's speed makes farther cover points better - Want to be far away from fast enemies.

	var theSpace = PhysicsServer2D.space_get_direct_state(get_world_2d().get_space())
	var validPoints : Array[Node] = []
	#var validPointsWeights : Array[Vector2] = []
	
	for i in globals.coversNode.get_children():
		if position.distance_squared_to(i.position) < 1200**2:
			validPoints.append(i)
	
	var validPoints2 : Array[Node] = []
	
	for i in validPoints:
		if not globals.canSeePoint(pointToSee, i.position, theSpace):
			validPoints2.append(i)


	if shootingBack:
		validPoints = []
		for i in validPoints2:
			for j in i.get_children():
				if globals.canSeePoint(j.global_position, pointToSee, theSpace):
					validPoints.append(i)
	else:
		validPoints = validPoints2
	
	validPoints.sort_custom(sortByDistanceFromUnit)
	
	if validPoints.size() > 0:
		return validPoints[0]
	else:
		return validPoints2[0]



func select() -> void:
	$canvasLayer/HUDDrawer.visible = true
	$canvasLayer/HUDDrawer.drawBool = true
	selected = true
	#$canvasLayer/selectedIcon.visible = true

func deselect() -> void:
	$canvasLayer/HUDDrawer.visible = false
	#$canvasLayer/HUDDrawer.drawBool = false
	selected = false
	#$canvasLayer/selectedIcon.visible = false

func unitReady() -> void:
	#$canvasLayer/selectedIcon.visible = false
	$unitNavAgent.target_desired_distance = 1
	
	#globals.navigationMap = $unitNavAgent.get_navigation_map()

func unitProcess() -> void:
	# make sure there are no recently freed units in seenHostiles
	
	cleanSeenHostiles()
	seenHostiles.sort_custom(sortByDistanceFromUnit)
	
	# detirmine where unit should be looking
	#region logic for detirmining where the unit should be looking
	if moveOrder != moveOrders.IDLE:
		if moveOrder == moveOrders.MOVETO and $lookTimer.time_left == 0:
			lookDest = dirToNextNavpoint
		elif moveOrder == moveOrders.RUNTO or moveOrder == moveOrders.CHARGE:
			lookDest = dirToNextNavpoint
			var seenHostilesInCone = []
			for i in seenHostiles:
				if i:
					if angleInCone(position.angle_to_point(i.position), lookDest, PI/6):
						seenHostilesInCone.append(i)

			if moveOrder == moveOrders.CHARGE:
				if seenHostiles.size() > 0:
					if global_position.distance_squared_to(seenHostiles[0].global_position) < meleeRange**2 and balance > 0.5:
						meleeAttack(seenHostiles[0])
			if moveOrder != moveOrders.CHARGE:
				if seenHostilesInCone.size() > 0:
					shootingTarget = seenHostilesInCone[0]
					lookDest = position.angle_to_point(shootingTarget.position)
				else:
					shootingTarget = null
					shootOrder = shootOrders.HOLDFIRE
	
	if shootOrder == shootOrders.FIREATWILL:
		if seenHostiles.size() > 0:
			if seenHostiles[0]:
				shootingTarget = seenHostiles[0]
				lookDest = (position.direction_to(shootingTarget.position)).angle()
			$lookTimer.start(2)
	#endregion
	
	# don't mess with this, testing stuff
	if gunRecharge > 0:
		gunRecharge -= 1
	if balance < maxBalance and velocity.length() < 2:
		balance += 0.005
	
	#if balance < 50:
	#	pass
	
	# handles making the unit look towards the lookDest
	#region turning logic
	if lookDir != lookDest:
		var counterDir = (lookDest-lookDir)
		var clockDir = (2*PI - counterDir)
		if counterDir < 0:
			clockDir = abs(counterDir)
			counterDir = (2*PI - clockDir)
		
		if abs(clockDir)<0.05 or abs(counterDir)<0.05:
			lookDir = lookDest
		else:
			if clockDir < counterDir:
				lookDir -= ((clockDir*0.95)* lookSpeed)+clockDir* lookSpeed
			elif clockDir > counterDir:
				lookDir += ((counterDir*0.95)* lookSpeed)+counterDir* lookSpeed
	#endregion
	
	
	#region gunning
	if shootingTarget != null and seenHostiles.find(shootingTarget)>=0 and shootOrder != shootOrders.HOLDFIRE:
		lookDest = (position.direction_to(shootingTarget.position)).angle()
		#$canvasLayer/selectedIcon/targetIcon.visible = true
		#$canvasLayer/selectedIcon/targetIcon.position = (shootingTarget).get_global_transform_with_canvas().origin
		if lookDir == lookDest: 
			var reloadPlease = false
			
			#var distanceMod : float = clampf(1-((position.distance_squared_to(shootingTarget.position)) / weapons[activeWeapon].effectiveRange[0])**2, 0.0, 1.0)
			currentAim = clampf(currentAim+((0.010)*weapons[activeWeapon].handling), 0.0, 1.0)
			
			var aimCondition : bool = false
			if burstType == burstTypes.PRECISION and currentAim == 1.0:
				aimCondition = true
			if burstType == burstTypes.FULLAUTO:
				aimCondition = true
			if burstType == burstTypes.BURST:
				if currentAim == 1.0:
					bursting = true
				if currentAim < 0.5:
					bursting = false
				if bursting:
					aimCondition = true
			
			if gunRecharge == 0 and aimCondition:
				if weapons[activeWeapon].currentMag:
					if weapons[activeWeapon].currentMag.currentAmmo > 0:
						#print("bang!")
						reloadPlease = false
						var hc = calculateHitChance(weapons[activeWeapon], shootingTarget)
						if hc > 0.0:
							performRangedAttack(shootingTarget, activeWeapon, hc)
					else:
						reloadPlease = true
				else:
					reloadPlease = true
			
			if ($taskTimer.is_stopped()) and backpackMags.size() > 0 and reloadPlease:
				reloadWeapon(activeWeapon)
	#else:
		#$canvasLayer/selectedIcon/targetIcon.visible = false
	if not shootingTarget:
		currentAim = 0.0
	#endregion

	if selected: 
		$canvasLayer/HUDDrawer.drawNavPath()
	#$canvasLayer/selectedIcon/lookIcon.rotation = lookDir
	#$canvasLayer/selectedIcon/moveIcon.rotation = dirToNextNavpoint
	#if moveOrder == moveOrders.RUNTO:
		#$canvasLayer/selectedIcon/moveIcon.visible = true
		#$canvasLayer/selectedIcon/moveIcon.texture = runIconTexture
	#elif moveOrder == moveOrders.MOVETO:
		#$canvasLayer/selectedIcon/moveIcon.visible = true
		#$canvasLayer/selectedIcon/moveIcon.texture = walkIconTexture
	#elif moveOrder == moveOrders.IDLE:
		#$canvasLayer/selectedIcon/moveIcon.visible = false
	#if $canvasLayer/selectedIcon.visible == true:
		#$canvasLayer/selectedIcon.position = get_global_transform_with_canvas().origin

func _process(_delta) -> void:
	unitProcess()
	
func _ready() -> void:
	unitReady()

func _physics_process(delta: float) -> void:
	if moveOrder != moveOrders.IDLE:
		var nav_point_direction = to_local($unitNavAgent.get_next_path_position()).normalized()
		dirToNextNavpoint = nav_point_direction.angle()
		if moveOrder == moveOrders.MOVETO:
			movement_speed = walkSpeed
		elif moveOrder == moveOrders.RUNTO or moveOrder == moveOrders.CHARGE:
			movement_speed = sprintSpeed
			
			
		if !$unitNavAgent.is_target_reached():
			moveTowardsPoint(to_local($unitNavAgent.get_next_path_position()), delta)
		else:
			moveOrder = moveOrders.IDLE
			timeInMoveOrder = 0
			print("made it")
		
		if balance < 0.5:
			if velocity != Vector2(0,0):
				velocity = velocity*0.9
			pass
				
		move_and_slide()

func _draw() -> void:
	pass

func _on_timer_timeout() -> void:
	timeInMoveOrder += 1
	timeInShootOrder += 1
	
	var dot = 0
	for i in statuses:
		if i[0] == statusesEnum.BLEED:
			dot += i[1]
			#print(self , " is bleeding for ", i[1], "new blood = ", blood)
	if dot > 0:
		takeDamage(dot)
	#print("tick")
	$Timer.start()

	# End of navigation code, do not mess with this

func _on_task_timer_timeout() -> void:
	if taskType == tasks.RELOAD:
		weapons[taskDetails["weaponToLoad"]].currentMag = backpackMags.pop_at(backpackMags.find(taskDetails["magToLoad"]))
	taskType = tasks.NOTASK
	armsState = armsStates.ATEASE
	taskDetails = null
