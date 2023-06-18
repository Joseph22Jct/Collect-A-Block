extends Node2D
class_name GameManager
var state = "Main"
var score = 0
var Difficulty = 0

func GetScore():
	pass
	
func GetState():
	pass
	
func AddScore(num):
	score+=num
	print(score)
	pass
# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.GameManager = self
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
