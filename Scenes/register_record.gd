extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$TextEdit.text_changed.connect(LimitLetters)
	pass # Replace with function body.

func LimitLetters():
	if(len($TextEdit.text)>10):
		$TextEdit.text = 	$TextEdit.text.substr(0,9)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass
