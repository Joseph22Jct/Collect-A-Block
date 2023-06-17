extends Node

var BoardManager 
var VisualBoard
var Cursor

func GetPosition(array):
	return Vector2(((array[1]-3)*32)+16,((array[0]-6)*32)+16 )
	pass
