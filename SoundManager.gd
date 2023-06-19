extends Node2D

class_name SoundManager

var SoundEffects = {
	"ChainTrigger": preload("res://SoundEffects/ChainTrigger.wav"),
	"Collect": preload("res://SoundEffects/Collect.wav"),
	"Insert":preload("res://SoundEffects/Insert.wav"),
	"Land": preload("res://SoundEffects/Land.wav"),
	"Move": preload("res://SoundEffects/Move.wav"),
	"Pop": preload("res://SoundEffects/Pop.wav"),
	"Select": preload("res://SoundEffects/Select.wav"),
	"Swap": preload("res://SoundEffects/Swap.wav")
}

var SoundEffectsVol = {
	"ChainTrigger": 50,
	"Collect": 30,
	"Insert":20,
	"Land": 50,
	"Move":40,
	"Pop": 50,
	"Select": 50,
	"Swap": 50
	
}

var Music = {
	"Normal" = preload("res://Music/music jam.wav"),
	"Critical" = preload("res://Music/music jam critical.wav")
}

func SetMusic(boolean):
	if(boolean):
		MusicVol = 1
		MusicObj.play()
	else:
		MusicVol = 0
		MusicObj.stop()
	pass
var MasterVolume = 1
var SFXVol = 1
var MusicVol=1
# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.SoundManager= self
	MusicObj = AudioStreamPlayer.new()
	add_child(MusicObj)
	pass # Replace with function body
	
#func _process(delta):
#	if(Input.is_action_just_pressed("Test")):
#		PlaySoundEffect("CursorMove")

func PlaySoundEffect(which, volume=100, pitch = 1):
	var AudioObj = AudioStreamPlayer.new()
	add_child(AudioObj)
	AudioObj.stream = SoundEffects[which]
	AudioObj.volume_db = (volume-(200-SoundEffectsVol[which]))/4 
	AudioObj.play()
	await get_tree().process_frame
	await AudioObj.finished
	AudioObj.queue_free()
	
	pass
	
var MusicObj
var curMus = ""
func PlayMusic(which):
	if curMus!=which:
		curMus = which
		MusicObj.stream = Music[which]
		MusicObj.volume_db = -25*MusicVol
		MusicObj.play()
		await get_tree().process_frame
		await MusicObj.finished
		PlayMusic(which)
	else:
		MusicObj.play()
		await get_tree().process_frame
		await MusicObj.finished
		PlayMusic(which)
	pass
	
func FreeAudio():
	pass
