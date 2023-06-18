extends Node2D

class_name BoardManager

var Board = [] ##BottomRow is inaccessible.
var gameSpeed = 0.3
var RiseTimer = gameSpeed*10
var cRT = 0
var cGST = 0
var collectedPieces = []
var fallingPieces = []
var currentChain = 0
var DangerTime = 1
var curDT = 0
var freezetime = false
var disable = false
var colors = 4
var timeForRowSpawn = 3 ##3 seconds for a row to spawn at slowest speed.
var cRowSpawnTime = 0
var cState = "Main"
var VB: VisualBoard 
var VisualPiece = preload("res://Scenes/piece.tscn")
var baseScore = 100
var comboMult = 1.00
var chainMult = 1.5
var CM : CollectManager

signal RisePieces()

# Called when the node enters the scene tree for the first time.
func _ready():
	
	Globals.BoardManager = self
	for x in range(13):
		Board.append([])
		for y in range(8):
			Board[x].append(null)
#	print(Board)
	colors = Globals.ColorDifficulty
	for x in range(7):
		InsertRow()
	
	await get_tree().process_frame
	VB = Globals.VisualBoard
	CM = Globals.CollectManager
	
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cGST +=delta
	if(cGST>= gameSpeed):
		cGST = 0
		GameSpeedProcess()
	pass

var PiecesToPop = []
func GameSpeedProcess():
	FallPieces()
	PopPieces()
	RiseBlocks()
	pass
	
var swapping = false

func Swap(posA, posB): ##Swaps two pieces on a board
	
	var PieceA = Board[posA[0]][posA[1]]
	var PieceB = Board[posB[0]][posB[1]]
	if(PieceA!=null): ##If either of them are popping, then do not swap
		if(PieceA.popping):
			return
	if(PieceB!=null):
		if(PieceB.popping):
			return
	Board[posA[0]][posA[1]] = PieceB ##Make swap
	Board[posB[0]][posB[1]] = PieceA
	if(PieceA!=null): ##If the piece isnt null, then do the swap animation
		PieceA.Swap(posB)
	if(PieceB!=null):
		PieceB.Swap(posA)
	swapping = true ##let the board know you are currently swapping
	await get_tree().create_timer(0.1).timeout ##Let animation finish
	
	
	CheckIfPop(posA) ##Check if anything pops from this, maybe check together
	CheckIfPop(posB)
	swapping = false ##let the game know that you finished swapping
	
	

	pass

func RiseBlocks(manual = false): ##If manual = true then rise all the way to the top
	if(freezetime):
		return

#	var tween1 = get_tree().create_tween()
#	tween1.tween_property(Globals.Cursor, "position", Globals.Cursor.position+Vector2(0, -cRT/RiseTimer * 32), gameSpeed)
#	var tween2 = get_tree().create_tween()
#	tween2.tween_property($VisualPieces, "position", Vector2(0, -cRT/RiseTimer * 32), gameSpeed)
	cRT+=gameSpeed
	if(cRT>=RiseTimer or manual):
#		await tween1.finished and tween2.finished
		cRT = 0
		InsertRow()
		
		$VisualPieces.position = Vector2(0,0)
	
	##TODO 
	pass

func InsertPiece(pos):
	var col = CM.Give()
	print("Insert!")
	if(col == -1):
		return
	var newPiece = VisualPiece.instantiate()
	$VisualPieces.add_child(newPiece)
	newPiece.initialize()
	Board[pos[0]][pos[1]] = newPiece
	
	newPiece.SetColor(col)
	newPiece.position = Globals.GetPosition(pos)
	newPiece.SetPos(pos)
	RegisterPiecesForFalling(pos)
	pass

func TakePiece(pos):
	print("Collect!")
	var tile:Node2D = Board[pos[0]][pos[1]]
	if(tile.popping or tile.falling or not CM.CanCollect()):
		return
	CM.Collect(tile.color)
	tile.popping = true
	tile.z_index = 10
	var tween = get_tree().create_tween()
	tween.tween_property(tile, "scale", Vector2(2,2), gameSpeed/1.5)
	var tween2 = get_tree().create_tween()
	tween2.tween_property(tile, "rotation_degrees", 90, gameSpeed/1.5)
	var tween3 = get_tree().create_tween()
	tween3.tween_property(tile, "modulate",  Color.TRANSPARENT, gameSpeed/1.5)
	await tween.finished
	Board[pos[0]][pos[1]] = null
	tile.queue_free()
	RegisterPiecesForFalling(pos)
	pass
	
func InsertRow():
	await get_tree().process_frame
	for x in Board[0]:
		if x!=null:##Game over??
			return
	RisePieces.emit()
			
	var newRow = []
	var prevColor = -1
	for x in range(len(Board[0])):
		var newPiece = VisualPiece.instantiate()
		$VisualPieces.add_child(newPiece)
		newPiece.initialize()
		newRow.append(newPiece)
		
		newPiece.color=prevColor
		newPiece.position = Globals.GetPosition([12,x])
		newPiece.SetPos([12,x])
		var upperColor = prevColor
		if(Board[len(Board)-1][x]!=null):
			upperColor = Board[len(Board)-1][x].color
		while(newPiece.color==prevColor or newPiece.color == upperColor ):
			newPiece.SetColor(randi_range(0, colors-1))
		prevColor = newPiece.color
		
		pass
	Board.append(newRow)
	Board.pop_at(0)
	
	
	
	pass

var PiecesToFall = []
var ArrayOfPops = []
func RegisterPiecesForFalling(pos): ##Pos is the blank pos it leaves
	for x in range(pos[0]+1):
		if(Board[x][pos[1]]==null):
			continue
		if(Board[x][pos[1]] in PiecesToFall):
			continue
		
		Board[x][pos[1]].falling = true
		PiecesToFall.append(Board[x][pos[1]]) 
		pass
	pass

func FallPieces():
	await get_tree().process_frame
	freezetime = true
	PiecesToFall = SortFallArray(PiecesToFall)
	var PiecesFallen = []
	
	while len(PiecesToFall)>0:
		
		for x in PiecesToFall:
			var cPos = x.pos
			if(Board[cPos[0]+1][cPos[1]] == null):
				Board[cPos[0]+1][cPos[1]] = x
				Board[cPos[0]][cPos[1]] = null
				x.Fall()
				PiecesFallen.append(x)
				PiecesToFall.erase(x)
			else:
				if(Board[cPos[0]+1][cPos[1]].falling == true):
					continue
				else:
					
					CheckIfPop(x.pos, true)
					
					PiecesToFall.erase(x)
	PiecesToFall = PiecesFallen
	
	var ComboConts = false
	
	for x in $VisualPieces.get_children():
		if x.falling == true or x.popping == true:
			ComboConts = true
			break
		
	if(not ComboConts):
		
		
		freezetime = false
		currentChain = 0
	
	
	pass
	
func SortFallArray(arr):
	var cur = 0 
	for x in range(len(arr)):
		if arr[cur]!=null:
			cur+=1
		else:
			arr.pop_at(cur)
	
	var n = len(arr)
	var swapped = false
	for i in range(n-1):

		for j in range(0, n-i-1):
			
			if arr[j].pos[0] < arr[j + 1].pos[0]:
				swapped = true
				var swap = arr[j]
				arr[j] = arr[j + 1]
				arr[j + 1] = swap
				

		if not swapped:

			continue
	return arr
	pass
	
func CheckIfPop(pos, chain=false): ##if chain == true then that means that if there is a pop then it increases the chain
	if(Board[pos[0]][pos[1]] == null):
		RegisterPiecesForFalling(pos)
		return
	Board[pos[0]][pos[1]].falling = false
	Board[pos[0]][pos[1]].popping = true
	var connectsToPop = RecurssiveCheck([], Board[pos[0]][pos[1]].color, pos, [])
	var combo = len(connectsToPop)
	if(combo<4):
		Board[pos[0]][pos[1]].popping = false
		RegisterPiecesForFalling(pos)
		return
	chainEnabled = chain
	
	PiecesToPop+= connectsToPop
	
	pass


var chainEnabled = false


func PopPieces():
	var combo = len(PiecesToPop)
		
	if(combo<4):
		PiecesToPop = []
		return
	if(chainEnabled):
		currentChain+=1
		var score = baseScore
		score *= (1+((combo-4)*comboMult))
		score *= (1+ (currentChain*chainMult))
		print("Chain "+str(currentChain)+" with a combo of: "+str(combo)+" and score: "+str(score))
		Globals.GameManager.AddScore(score)
		
	else:
		if(currentChain<1):
			currentChain = 1
		var score = baseScore
		score *= (1+((combo-4)*comboMult))
		print("Chain start with a combo of: "+str(combo)+" and score: "+str(score))
		Globals.GameManager.AddScore(score)
		
	var PosArray = []
	var arr = PiecesToPop
	ArrayOfPops.append(PiecesToPop)
	var curPop = len(ArrayOfPops)-1
	PiecesToPop = []
	for x in arr:
		if(x == null):
			continue
		x.popping = true 
	for x in arr:
		if(x == null):
			continue
		var tween = get_tree().create_tween()
		tween.tween_property(x, "scale", Vector2(0,0), gameSpeed/1.5)
		await tween.finished
		PosArray.append(x)
		
		
	for x in PosArray:
		if(x == null):
			continue
		Board[x.pos[0]][x.pos[1]] = null
		x.queue_free()
		RegisterPiecesForFalling(x.pos)
	
	if(len(ArrayOfPops)>curPop):
		ArrayOfPops.pop_at(curPop)
		
	
	

func RecurssiveCheck(posList, color,pos, totalConnects):
	if(pos[0]<0 or pos[1]<0):
		return totalConnects
	if(pos[0]>len(Board)-2 or pos[1]>len(Board[0])-1):
		return totalConnects
		
	if(Board[pos[0]][pos[1]] in posList):
		return totalConnects
	posList.append(Board[pos[0]][pos[1]])
	if(Board[pos[0]][pos[1]] == null):
		return totalConnects
	if color == Board[pos[0]][pos[1]].color and not Board[pos[0]][pos[1]].falling:
		totalConnects.append(Board[pos[0]][pos[1]])
	else:
		return totalConnects
	
	RecurssiveCheck(posList, color, [pos[0]+1,pos[1]], totalConnects)
	RecurssiveCheck(posList, color, [pos[0]-1,pos[1]], totalConnects)
	RecurssiveCheck(posList, color, [pos[0],pos[1]+1], totalConnects)
	RecurssiveCheck(posList, color, [pos[0],pos[1]-1], totalConnects)
	return totalConnects
	pass
