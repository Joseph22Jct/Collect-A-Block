extends Node2D


class_name Piece

var color = 0
#var adjacentPieces = []
var pos= [0,0]
var falling = false
var swapped = false
var popping = false
func initialize():
	var BM: BoardManager = Globals.BoardManager
	BM.RisePieces.connect(Rise)
	
	
func SetColor(num):
	color = num
	$BG.region_rect = Rect2(color*32,0,32,32)
	$Icon.region_rect = Rect2(color*32,64,32,32)
	$Border.region_rect = Rect2(color*32,32,32,32)
	pass

func SetPos(p):
	pos = p
	position = Globals.GetPosition(p)
	pass

func Rise():
	SetPos([pos[0]-1,pos[1]])

func Swap(nPos):
	SetPos(nPos)

func Fall():
	SetPos([pos[0]+1,pos[1]])
