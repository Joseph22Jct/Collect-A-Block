extends Node2D

var Board = [] ##BottomRow is inaccessible.
var gameSpeed = 1
var collectedPieces = []
var fallingPieces = []
var currentChain = 0
var DangerTime = 1
var curDT = 0
var freeze = false
var colors = 4
var timeForRowSpawn = 3 ##3 seconds for a row to spawn at slowest speed.
var cRowSpawnTime = 0
var cState = "Main"

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(13):
		Board.append([])
		for y in range(6):
			Board[x].append(null)
	print(Board)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func GameSpeedProcess(delta):
	pass

func SwapPiece():
	pass
	
func InsertPiece():
	pass

func TakePiece():
	pass
	
func InsertRow():
	pass
	
func RegisterPiecesForFalling():
	pass

func FallPieces():
	pass

	
func CheckIfPop():
	pass
