extends Node2D
class_name GameManager
var state = "Main"
var score = 0
var Difficulty = 0
var level = 1

func GetScore():
	return score
	pass
	
func GetState():
	pass
	
func AddScore(num):
	score+=num
	print(score)
	$ScoreLabel.text = str(score)
	ManageSpeed()
	pass

func ManageSpeed():
	level = int(score/1000)+1
	if(level>50):
		level = 50
	$Level.text = str(level)
	Globals.BoardManager.gameSpeed = 0.55 - ((level-1)*0.01)
	pass
# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.GameManager = self
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
