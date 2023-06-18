extends Node2D
class_name Cursor

var curPos = [12,2]
var curMode = 0
var BM : BoardManager

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.Cursor = self
	await get_tree().process_frame
	BM = Globals.BoardManager
	position = Globals.GetPosition(curPos)
	BM.RisePieces.connect(Rise)
	pass # Replace with function body.
func Swap():
	if(curMode == 0):
		BM.Swap(curPos, [curPos[0],curPos[1]+1])
	else:
		$sprite.visible= true
		$Highlight.visible = false
		curMode = 0
		if curPos[1]==len(BM.Board[0])-1:
			MoveCursor([curPos[0], curPos[1]-1])
			pass
	pass
	
func EnableCollect(which):
	if(curMode ==0):
		$sprite.visible= false
		$Highlight.visible = true
		curMode = 1
		if(which == 1):
			MoveCursor([curPos[0], curPos[1]+1])
	else: 
		if(BM.Board[curPos[0]][curPos[1]] !=null):
			BM.TakePiece(curPos)
		else:
			BM.InsertPiece(curPos)
func Rise():
	MoveCursor([curPos[0]-1,curPos[1]])

func MoveCursor(pos):
	if(pos[0]<0 or pos[1]<0):
		return
	var spacing = 2
	if(curMode ==1):
		spacing = 1
	if(pos[0]>len(BM.Board)-2 or pos[1]>len(BM.Board[0])-spacing):
		return
	curPos = [pos[0], pos[1]]
	var tween1 = get_tree().create_tween()
	tween1.tween_property(Globals.Cursor, "position", Globals.GetPosition(curPos), 0.05)
#	position = Globals.GetPosition(curPos)
	if(BM.Board[curPos[0]][curPos[1]]!=null):
		print("Pos at "+str(curPos)+" where board is: "+ str(BM.Board[curPos[0]][curPos[1]].color))
	else:
		print("Pos at "+str(curPos)+" where board has no color")
	pass

func RiseBlocks():
	BM.RiseBlocks(true)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_action_just_pressed("Up")):
		MoveCursor([curPos[0]-1,curPos[1]])
		pass
	elif(Input.is_action_just_pressed("Down")):
		MoveCursor([curPos[0]+1,curPos[1]])
		pass	
	if(Input.is_action_just_pressed("Left")):
		MoveCursor([curPos[0],curPos[1]-1])
		pass
	elif(Input.is_action_just_pressed("Right")):
		MoveCursor([curPos[0],curPos[1]+1])
		pass
	if(Input.is_action_just_pressed("Swap")):
		Swap()
		pass
	if(Input.is_action_just_pressed("CollectL")):
		EnableCollect(0)
		pass	
	if(Input.is_action_just_pressed("CollectR")):
		EnableCollect(1)
		pass
	if(Input.is_action_just_pressed("RiseBlocks")):
		RiseBlocks()
		pass
	pass
