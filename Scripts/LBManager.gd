extends Node
class_name LBManager
# Use this game API key if you want to test it with a functioning leaderboard
# "987dbd0b9e5eb3749072acc47a210996eea9feb0"
var game_API_key = "dev_cf03cc18fd884fabb1efc1e81b3ddb58"   # "dev_9ac82231ac724a01a0a9d698bc749af7"
var development_mode = true
var leaderboard_key = "LBKey"
var session_token = ""
var score = 0
var PlayerName = "Peepee!"
# HTTP Request node can only handle one call per node
var auth_http = HTTPRequest.new()
var leaderboard_httpE = HTTPRequest.new()
var leaderboard_httpM = HTTPRequest.new()
var leaderboard_httpH = HTTPRequest.new()
var submit_score_http = HTTPRequest.new()
var set_name_http = HTTPRequest.new()
var get_name_http = HTTPRequest.new()
var leaderboard_http
var EasyKey = "EasyPGLB"
var MediumKey = "MediumPGLB"
var HardKey = "HardPGLB"

var EasyLB = []
var MediumLB  = []
var HardLB = []

signal LBGathered(which, scores)
func _ready():
	_authentication_request()
	await get_tree().process_frame
	Globals.LBManager = self

func _process(_delta):
	pass
#	if(Input.is_action_just_pressed("ui_up")):
#		score += 1
#		print("CurrentScore:"+str(score))
#
#	if(Input.is_action_just_pressed("ui_down")):
#		score -= 1
#		print("CurrentScore:"+str(score))
#
#	# Upload score when pressing enter
#	if(Input.is_action_just_pressed("ui_accept")):
#		_upload_score(score)
#
#	# Get score when pressing spacebar
#	if(Input.is_action_just_pressed("ui_select")):
#		_get_leaderboards()


func _authentication_request():
	# Check if a player session has been saved
	var player_session_exists = false
	var file = FileAccess.open("user://Lootlocker.data", FileAccess.READ)
	var player_identifier = str(file)
#	print(file)
	file = null
	if(player_identifier.length() > 1):
		player_session_exists = true
		
	## Convert data to json string:
	var data = { "game_key": game_API_key, "game_version": "0.0.0.1", "development_mode": true }
	
	# If a player session already exists, send with the player identifier
	if(player_session_exists == true):
		data = { "game_key": game_API_key, "player_identifier":player_identifier, "game_version": "0.0.0.1", "development_mode": true }
	
	# Add 'Content-Type' header:
	var headers = ["Content-Type: application/json"]
	
	# Create a HTTPRequest node for authentication
	auth_http = HTTPRequest.new()
	add_child(auth_http)
	auth_http.request_completed.connect(_on_authentication_request_completed)
	# Send request
	auth_http.request
	auth_http.request("https://api.lootlocker.io/game/v2/session/guest", headers, \
	HTTPClient.METHOD_POST, JSON.stringify(data))
	# Print what we're sending, for debugging purposes:
#	print(data)


func _on_authentication_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	
	# Save player_identifier to file
	var file = FileAccess.open("user://LootLocker.data", FileAccess.WRITE)
	print(json["player_identifier"])
	file.store_string(json["player_identifier"])
	file.close()
	
	# Save session_token to memory
	session_token = json.session_token
	
	# Print server response
	print(json)
	
	# Clear node
	auth_http.queue_free()
	# Get leaderboards
	_get_leaderboards(0)


func _get_leaderboards(which):
	match which:
		0: 
			leaderboard_key = EasyKey
		1: 
			leaderboard_key = MediumKey
		2: 
			leaderboard_key = HardKey
	print("Getting leaderboards")
	var url = "https://api.lootlocker.io/game/leaderboards/"+leaderboard_key+"/list?count=10"
	var headers = ["Content-Type: application/json", "x-session-token:"+session_token]
	
	
	match which:
		0: 
			leaderboard_httpE = HTTPRequest.new()
			add_child(leaderboard_httpE)
			leaderboard_httpE.request_completed.connect(E_on_leaderboard_request_completed)
			# Send request
			leaderboard_httpE.request(url, headers, HTTPClient.METHOD_GET, "")
		1: 
			leaderboard_httpM = HTTPRequest.new()
			add_child(leaderboard_httpM)
			leaderboard_httpM.request_completed.connect(M_on_leaderboard_request_completed)
			# Send request
			leaderboard_httpM.request(url, headers, HTTPClient.METHOD_GET, "")
			
		2: 
			leaderboard_httpH = HTTPRequest.new()
			add_child(leaderboard_httpH)
			leaderboard_httpH.request_completed.connect(H_on_leaderboard_request_completed)
			# Send request
			leaderboard_httpH.request(url, headers, HTTPClient.METHOD_GET, "")
			
	# Create a request node for getting the highscore
	
	
	


func E_on_leaderboard_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	
	# Print data
	print(json)
	
	# Formatting as a leaderboard
	var leaderboardFormatted = ""
	if("items" in json):
		for n in json.items.size():
			leaderboardFormatted += str(json.items[n].rank)+str(". ")
			#leaderboardFormatted += str(json.items[n].player.id)+str(" - ")
			leaderboardFormatted += str(json.items[n].player.name)+str(" - ")
			leaderboardFormatted += str(json.items[n].score)+str("\n")
		
	# Print the formatted leaderboard to the console
	print(leaderboardFormatted)
	
	emit_signal("LBGathered","0", leaderboardFormatted)
	
	# Clear node
	leaderboard_httpE.queue_free()

func M_on_leaderboard_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	
	# Print data
	print(json)
	
	# Formatting as a leaderboard
	var leaderboardFormatted = ""
	if("items" in json):
		for n in json.items.size():
			leaderboardFormatted += str(json.items[n].rank)+str(". ")
			#leaderboardFormatted += str(json.items[n].player.id)+str(" - ")
			leaderboardFormatted += str(json.items[n].player.name)+str(" - ")
			leaderboardFormatted += str(json.items[n].score)+str("\n")
		
	# Print the formatted leaderboard to the console
	print(leaderboardFormatted)
	
	emit_signal("LBGathered","1", leaderboardFormatted)
	
	# Clear node
	leaderboard_httpM.queue_free()
	
func H_on_leaderboard_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	
	# Print data
	print(json)
	
	# Formatting as a leaderboard
	var leaderboardFormatted = ""
	if("items" in json):
		for n in json.items.size():
			leaderboardFormatted += str(json.items[n].rank)+str(". ")
			#leaderboardFormatted += str(json.items[n].player.id)+str(" - ")
			leaderboardFormatted += str(json.items[n].player.name)+str(" - ")
			leaderboardFormatted += str(json.items[n].score)+str("\n")
		
	# Print the formatted leaderboard to the console
	print(leaderboardFormatted)
	
	emit_signal("LBGathered","2", leaderboardFormatted)
	
	# Clear node
	leaderboard_httpH.queue_free()

func _upload_score(which, score):
	match which:
		0: 
			leaderboard_key = EasyKey
		1: 
			leaderboard_key = MediumKey
		2: 
			leaderboard_key = HardKey
	var data = { "score": str(score)}
	var headers = ["Content-Type: application/json", "x-session-token:"+session_token]
	submit_score_http = HTTPRequest.new()
	add_child(submit_score_http)
	_change_player_name()
	submit_score_http.request_completed.connect(_on_upload_score_request_completed)
	# Send request
	submit_score_http.request("https://api.lootlocker.io/game/leaderboards/"+leaderboard_key+"/submit", headers, HTTPClient.METHOD_POST, JSON.stringify(data))
	# Print what we're sending, for debugging purposes:
	print(data)


func _on_upload_score_request_completed(result, response_code, headers, body) :
	var json = JSON.parse_string(body.get_string_from_utf8())
	
	# Print data
	print(json)
	
	# Clear node
	submit_score_http.queue_free()
	

func _change_player_name():
	print("Changing player name")
	
	# use this variable for setting the name of the player
	var player_name = PlayerName
	
	var data = { "name": str(player_name) }
	var url =  "https://api.lootlocker.io/game/player/name"
	var headers = ["Content-Type: application/json", "x-session-token:"+session_token]
	
	# Create a request node for getting the highscore
	set_name_http = HTTPRequest.new()
	add_child(set_name_http)
	set_name_http.request_completed.connect(_on_player_set_name_request_completed)
	# Send request
	set_name_http.request(url, headers, HTTPClient.METHOD_PATCH, JSON.stringify(data))
	
func _on_player_set_name_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	
	# Print data
	print(json.name)
	set_name_http.queue_free()

func _get_player_name():
	print("Getting player name")
	var url = "https://api.lootlocker.io/game/player/name"
	var headers = ["Content-Type: application/json", "x-session-token:"+session_token]
	
	# Create a request node for getting the highscore
	get_name_http = HTTPRequest.new()
	add_child(get_name_http)
	get_name_http.request_completed.connect(_on_player_get_name_request_completed)
	# Send request
	get_name_http.request(url, headers, HTTPClient.METHOD_GET, "")

func _on_player_get_name_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	
	# Print data
	print(json)
	# Print player name
	print(json.name)
