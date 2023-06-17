extends Node2D
class_name VisualBoard
var VisualPiece = preload("res://Scenes/piece.tscn")
var BM : BoardManager

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.VisualBoard = self
	await get_tree().process_frame
	BM = Globals.BoardManager
	BM.RisePieces.connect(RisePieces)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func Initialize():
	for y in range(len(BM.Board)):
		for x in range(len(BM.Board[0])):
			if(BM.Board[y][x] == null):
				continue
			else:
				var newP = VisualPiece.instantiate()
				newP.SetPiece(BM.Board[y][x].color)
				newP.position = Globals.GetPosition([y,x])
				$VisualPieces.add_child(newP)
		pass
	pass
func RisePieces():
	
	pass

func FallPieces():
	pass

func SwapPieces():
	pass
	
func DangerPieces():
	pass
	
func PopPieces():
	pass

func ShowCombo():
	pass
