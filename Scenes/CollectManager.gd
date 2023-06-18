extends Node2D
class_name CollectManager

var CollectedPieces = []
var VisualPiece = preload("res://Scenes/piece.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.CollectManager = self
	pass # Replace with function body.

func Collect(type):
	var VP = VisualPiece.instantiate()
	add_child(VP)
	VP.SetColor(type)
	CollectedPieces.append(VP)
	UpdateSlots()
	pass

func Give():
	if(len(CollectedPieces) ==0):
		return -1
	var tileToGive = CollectedPieces.pop_at(0)
	var col = tileToGive.color
	tileToGive.queue_free()
	UpdateSlots()
	return col
	
func UpdateSlots():
	for x in range(len(CollectedPieces)):
		CollectedPieces[x].position = Vector2(0, -(x-2)*48)
		pass
	
func CanCollect():
	var boolean = true
	if(len(CollectedPieces)>2):
		boolean = false
	return boolean
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
