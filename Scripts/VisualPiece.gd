extends Sprite2D
var type = 0
func SetPiece(num):
	type = num
	$BG.region_rect = Rect2(type*32,0,32,32)
	$Icon.region_rect = Rect2(type*32,64,32,32)
	$Border.region_rect = Rect2(type*32,32,32,32)
	pass
