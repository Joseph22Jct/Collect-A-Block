extends Node

var BoardManager 
var VisualBoard
var Cursor
var GameManager
var CollectManager
var ColorDifficulty = 4

func GetPosition(array):
	return Vector2(((array[1]-4)*32)+16,((array[0]-6)*32)+16 )
	pass
