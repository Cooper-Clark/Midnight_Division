extends CanvasItem

# GLOBAL VARS
@onready var playerUnits = get_node("units/playerUnits").find_children("*", "", false, false)
# GLOBAL VARS END


var recalcTimer = 5
var theQuadTree = quadTree.new()
var wW = 4096 # world width 500, 250, 125, 62.5, 31.25
var wH = 4096 #world height 400, 200, 100, 50, 25, 12.5
# 2 4 8 16 32 64 128 256 512 1024

var testingArray = []

class quadTree:
	
	var rect = null
	var thresh = null
	var zones = []
	var elements = []
	
	func _init(rectA = Rect2(0,0,0,0), threshA = 1, zones = [], elements = []):
		#area =  [world position, size as local vector]
		rect = rectA
		thresh = threshA
		pass
	#var test = position.x
	
	func whichQuadrant(point, areaArg) -> int:
		var q = 0
		if (point.position.x > areaArg.position.x+(areaArg.size.x/2)):
			q += 1
		if (point.position.y > areaArg.position.y+(areaArg.size.y/2)):
			q += 2
		return q
	
	func insertInTree(elem) -> void:
		if (self.zones.size() > 0):
			var intersecting = whichQuadrant(elem, self.rect)
			zones[intersecting].insertInTree(elem)
			return
		
		self.elements.append(elem)
		if (self.elements.size() > self.thresh):
			var newSize = self.rect.size.x / 2
			self.zones = [
				quadTree.new(Rect2(self.rect.position.x , self.rect.position.y , newSize , newSize) , self.thresh),
				quadTree.new(Rect2(self.rect.position.x + newSize, self.rect.position.y, newSize , newSize) , self.thresh),
				quadTree.new(Rect2(self.rect.position.x, self.rect.position.y + newSize, newSize , newSize), self.thresh),
				quadTree.new(Rect2(self.rect.position.x + newSize, self.rect.position.y + newSize, newSize , newSize), self.thresh)
			]
			for i in self.elements:
				self.insertInTree(i)
			self.elements = []

func _ready() -> void:
	#_draw()
	pass

func _process(_delta) -> void:
	if recalcTimer <= 0:
		var enemyList = get_node("units/enemyUnits").find_children("*", "", false, false)
		theQuadTree = quadTree.new(Rect2(0,0,wW,wH),1)
		for i in enemyList:
			theQuadTree.insertInTree(i)
			pass
		print(enemyList)
		recalcTimer = 500000
	
		testingArray = []
		addQuadToTest(theQuadTree)
	queue_redraw()
	_draw()
	recalcTimer -= 1

func addQuadToTest(quadID) -> void:
	testingArray.append(quadID.rect)
	if quadID.zones.size() > 0:
		for i in quadID.zones:
			addQuadToTest(i)

func _draw() -> void:
	#for i in [Rect2(0,0,100,100) , Rect2(1000,0,100,100)]:
		#draw_rect(i , Color(0.635, 0.547, 0.812, 1.0) , true, 1, false)
	
	for i in testingArray:
		draw_rect(i , Color(0.44, 0.37, 0.65, 1.0), false, 10, false)
		
	
