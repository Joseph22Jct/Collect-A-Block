extends Node2D
class_name MainMenu
var curChoice = 0 
var curState = "Main"
var MainGame = preload("res://main_scene.tscn")
var currentGame 
var PlayerName = ""
var score = 0
var difficulty = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.MainMenu = self
	await get_tree().process_frame
	Globals.SoundManager.PlayMusic("Normal")
	pass # Replace with function body.

func FinishGame(diff,scor):
	get_node("MainScene").queue_free()
	curState = "Record"
	difficulty = diff - 4
	score = scor
	$RegisterRecord.visible = true
	$RegisterRecord/ScoreLabel.text = str(score)
	var difftext
	match difficulty:
		0:
			difftext= "You got an Easy mode score of: "
		1:
			difftext= "You got an Medium mode score of: "
		2:
			difftext= "You got a Hard mode score of: "
	$RegisterRecord/modeLabel.text = difftext
	$RegisterRecord/SubmitButton.pressed.connect(SubmitScore)
	$RegisterRecord/ToMainMenu.pressed.connect(GoToMainMenu)

func SubmitScore():
	Globals.LBManager.PlayerName = $RegisterRecord/TextEdit.text
	Globals.LBManager._change_player_name()
	Globals.LBManager._upload_score(difficulty, score)
	GoToMainMenu()
	pass

func GoToMainMenu():
	$RegisterRecord.visible = false
	curState = "Main"
	$Control.visible = true
	$Control/Label.visible = true
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(curState == "Main"):
		if(Input.is_action_just_pressed("CollectL") or Input.is_action_just_pressed("CollectR") or Input.is_action_just_pressed("Swap") or Input.is_action_just_pressed("RiseBlocks")):
			Globals.SoundManager.PlaySoundEffect("Select")
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
	
	elif(curState == "LBs"):
		if(Input.is_action_just_pressed("Swap")):
			Globals.SoundManager.PlaySoundEffect("Select")
			curState = "Select"
			$Control/TextureRect.visible = true
			$Control/Label.visible = false
			$Control/DifficultyLabel.visible = true
			$Control/DifficultyChoice.visible = true
			$"Control/2D cursor".visible = true
			$Leaderboards.visible = false
		pass
func PlaceCursor():
	if(curChoice<0):
		curChoice = len($Control/DifficultyChoice.get_children())-1
	elif(curChoice>len($Control/DifficultyChoice.get_children())-1):
		curChoice = 0
	print(curChoice)
	$"Control/2D cursor".position = $Control/DifficultyChoice.get_children()[curChoice].position - Vector2(24,30)
	Globals.SoundManager.PlaySoundEffect("Move")
	pass

func Execute():
	Globals.SoundManager.PlaySoundEffect("Select")
	curState = "Game"
	match(curChoice): ##TODO
		0:
			$Control.visible = false
			$Control/Label.visible = true
			$Control/DifficultyLabel.visible = false
			$Control/DifficultyChoice.visible = false
			$"Control/2D cursor".visible = false
			Globals.ColorDifficulty = 4
			currentGame = MainGame.instantiate()
			add_child(currentGame)
			
			pass
		1:
			$Control.visible = false
			$Control/Label.visible = true
			$Control/DifficultyLabel.visible = false
			$Control/DifficultyChoice.visible = false
			$"Control/2D cursor".visible = false
			Globals.ColorDifficulty = 5
			currentGame = MainGame.instantiate()
			add_child(currentGame)
			pass
		2:
			$Control.visible = false
			$Control/Label.visible = true
			$Control/DifficultyLabel.visible = false
			$Control/DifficultyChoice.visible = false
			$"Control/2D cursor".visible = false
			Globals.ColorDifficulty = 6
			currentGame = MainGame.instantiate()
			add_child(currentGame)
			pass
		3:
			curState = "LBs"
			$Control/TextureRect.visible = false
			$Control/Label.visible = false
			$Control/DifficultyLabel.visible = false
			$Control/DifficultyChoice.visible = false
			$"Control/2D cursor".visible = false
			$Leaderboards.visible = true
			$Leaderboards.InitializeLBs()
			pass
		4:
			curState = "Select"
			musicON = not musicON
			if(musicON):
				
				$Control/DifficultyChoice/Music.text = "Music ON"
			else:
				$Control/DifficultyChoice/Music.text = "Music OFF"
			
			Globals.SoundManager.SetMusic(musicON)
			pass
		5:
			
			pass
	pass
var musicON = true
