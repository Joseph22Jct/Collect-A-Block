extends Node2D


class_name Piece

var color = 0
#var adjacentPieces = []
var pos= [0,0]
var falling = false
var swapped = false
var popping = false
var tween 
var BM: BoardManager 
func initialize():
	
	BM= Globals.BoardManager
	BM.RisePieces.connect(Rise)
	
	tween = get_tree().create_tween()
	
	
func SetColor(num):
	color = num
	$BG.region_rect = Rect2(color*32,0,32,32)
	$Icon.region_rect = Rect2(color*32,64,32,32)
	$Border.region_rect = Rect2(color*32,32,32,32)
	pass

func SetPos(p,time = BM.gameSpeed - BM.cGST):
	pos = p
#	if(tween.is_running()):
#		tween.chain().tween_property(self, "position", Globals.GetPosition(p), time)
#	else:
#		tween = get_tree().create_tween()
#		tween.tween_property(self, "position", Globals.GetPosition(p), time)
#	await tween.finished
	position = Globals.GetPosition(p)
	pass

func Rise():
	SetPos([pos[0]-1,pos[1]])
#	pos = [pos[0]-1,pos[1]]
#	position = Globals.GetPosition(pos)
	

func Swap(nPos):
	SetPos(nPos,0.1)

func Fall():
	
	SetPos([pos[0]+1,pos[1]])
