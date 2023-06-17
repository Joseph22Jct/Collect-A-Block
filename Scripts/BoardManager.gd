extends Node2D

class_name BoardManager

var Board = [] ##BottomRow is inaccessible.
var gameSpeed = 0.5
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

signal RisePieces()



# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.BoardManager = self
	for x in range(13):
		Board.append([])
		for y in range(6):
			Board[x].append(null)
#	print(Board)
	for x in range(7):
		InsertRow()
	
	await get_tree().process_frame
	VB = Globals.VisualBoard
	
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cGST +=delta
	if(cGST>= gameSpeed):
		cGST = 0
		GameSpeedProcess()
	pass
	
func GameSpeedProcess():
	FallPieces()
	pass

func Swap(posA, posB):
	var PieceA = Board[posA[0]][posA[1]]
	var PieceB = Board[posB[0]][posB[1]]
	if(PieceA!=null):
		if(PieceA.popping):
			return
	if(PieceB!=null):
		if(PieceB.popping):
			return
	Board[posA[0]][posA[1]] = PieceB
	Board[posB[0]][posB[1]] = PieceA
	if(PieceA!=null):
		PieceA.Swap(posB)
	if(PieceB!=null):
		PieceB.Swap(posA)
	
	CheckIfPop(posA)
	CheckIfPop(posB)
	
	RegisterPiecesForFalling(posA)

	RegisterPiecesForFalling(posB)
	pass
	
func InsertPiece():
	pass

func TakePiece():
	pass
	
func InsertRow():
	for x in Board[0]:
		if x!=null:
			return
	RisePieces.emit()
			
	var newRow = []
	var prevColor = -1
	for x in range(len(Board[0])):
		var newPiece = VisualPiece.instantiate()
		newPiece.initialize()
		
		newPiece.color=prevColor
		newPiece.SetPos([12,x])
		var upperColor = prevColor
		if(Board[len(Board)-1][x]!=null):
			upperColor = Board[len(Board)-1][x].color
		while(newPiece.color==prevColor or newPiece.color == upperColor ):
			newPiece.SetColor(randi_range(0, colors-1))
		prevColor = newPiece.color
		newRow.append(newPiece)
		$VisualPieces.add_child(newPiece)
		pass
	Board.append(newRow)
	Board.pop_at(0)
	
	
	
	pass

var PiecesToFall = []
	
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
				CheckIfPop(x.pos, true)
				x.falling = false
				PiecesToFall.erase(x)
	PiecesToFall = PiecesFallen
	pass
	
func SortFallArray(arr):
	for x in range(len(arr)):
		if arr[x] == null:
			arr.pop_at(x)
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
		return
	var connectsToPop = RecurssiveCheck([], Board[pos[0]][pos[1]].color, pos, [])
	var combo = len(connectsToPop)
	if(combo<4):
		return
	PopPieces(connectsToPop)
	pass

func PopPieces(array):
	var PosArray = []
	for x in array:
		PosArray.append(x.pos)
		Board[x.pos[0]][x.pos[1]] = null
		x.queue_free()
		
	for x in PosArray:
		RegisterPiecesForFalling(x)
		
	
	

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
	if color == Board[pos[0]][pos[1]].color:
		totalConnects.append(Board[pos[0]][pos[1]])
	else:
		return totalConnects
	
	RecurssiveCheck(posList, color, [pos[0]+1,pos[1]], totalConnects)
	RecurssiveCheck(posList, color, [pos[0]-1,pos[1]], totalConnects)
	RecurssiveCheck(posList, color, [pos[0],pos[1]+1], totalConnects)
	RecurssiveCheck(posList, color, [pos[0],pos[1]-1], totalConnects)
	return totalConnects
	pass
