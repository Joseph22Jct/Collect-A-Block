extends Node2D

var curChoice = 0 
var curState = "Main"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(curState == "Main"):
		if(Input.is_action_just_pressed("CollectL") or Input.is_action_just_pressed("CollectR") or Input.is_action_just_pressed("Swap") or Input.is_action_just_pressed("RiseBlocks")):
			curState = "Select"
			$Control/Label.visible = false
			$Control/DifficultyLabel.visible = true
			$Control/DifficultyChoice.visible = true
			$"Control/2D cursor".visible = true
			PlaceCursor()
	elif(curState == "Select"):
		if(Input.is_action_just_pressed("Right") or Input.is_action_just_pressed("Down")):
			curChoice+=1
			PlaceCursor()
		if(Input.is_action_just_pressed("Left") or Input.is_action_just_pressed("Up")):
			curChoice-=1
			PlaceCursor()
		if(Input.is_action_just_pressed("Swap")):
			Execute()
		pass
	pass
func PlaceCursor():
	if(curChoice<0):
		curChoice = len($Control/DifficultyChoice.get_children())-1
	elif(curChoice>len($Control/DifficultyChoice.get_children())-1):
		curChoice = 0
	print(curChoice)
	$"Control/2D cursor".position = $Control/DifficultyChoice.get_children()[curChoice].position - Vector2(24,30)
	
	pass

func Execute():
	match(curChoice): ##TODO
		0:
			pass
		1:
			pass
		2:
			pass
		3:
			pass
		4:
			pass
		5:
			pass
	pass
