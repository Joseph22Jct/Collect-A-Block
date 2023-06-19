extends Control

var EasyKey = ""
var MediumKey = ""
var HardKey = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func InitializeLBs():
	$easy/LB.text = "Loading..."
	$medium/LB.text = "Loading..."
	$Hard/LB.text = "Loading..."
	Globals.LBManager.LBGathered.connect(ShowLB)
	Globals.LBManager._get_leaderboards(0)
	Globals.LBManager._get_leaderboards(1)
	Globals.LBManager._get_leaderboards(2)
	pass

func ShowLB(which, scores):
	match which:
		"0":
			print("Loaded Easy scores!")
			$easy/LB.text = scores
			pass
		"1":
			print("Loaded Medium scores!")
			$medium/LB.text = scores
			pass
		"2":
			print("Loaded Hard scores!")
			$Hard/LB.text = scores
			pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
