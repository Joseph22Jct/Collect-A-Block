extends Node2D

var stayScreen = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func SetUp(pos, chain, combo):
	position = Globals.GetPosition(pos)
	if(chain>=2 and chain<10):
		
		$chain.region_rect = Rect2((chain-2)*20,0,20,16)
		pass
	elif(chain>=10):
		$chain.region_rect = Rect2(10*20,0,20,16)
	else:
		$chain.visible = false
	if(combo>4):
		$combo/ComboLabel.text = str(combo)
		pass
	else: 
		$combo.visible = false
	if(combo>4 and chain>=2):
		$combo.position+=Vector2(20,0)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	stayScreen+=delta
	position+=Vector2(0,-delta/(stayScreen/12))
	if(stayScreen>0.8):
		queue_free()
	pass
