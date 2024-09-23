extends Node2D

@export var containerPage: Node
@export var mwq: MWQ

# Define a variable to hold the current user
var current_player = {}

# Reference to the HTTPRequest node
#@onready var http_request = $HttpRequest



func mwq_receive_player(player):
	print("mwq_receive_player")
	print(player)

	%LabelCurrentPlayer.text = player.username
	#username_label.text = player.username


# Called when the node enters the scene tree for the first time.
func _ready():
	mwq.x_identify()
	mwq.x_change_page("res://templates/WorldTemplate1/pages/Home.tscn", containerPage)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_about_me_button_up() -> void:
	mwq.x_change_page("res://templates/WorldTemplate1/pages/AboutMe.tscn", containerPage)





#
#func _on_identify_callback(result, response_code, headers, body):
	#if response_code == 200:  # HTTP OK
		##var json = JSON.new()
		##var response_data = JSON.new().parse(body.get_string_from_utf8())
		##print(response_data)
#
		##var json = JSON.new()
		##var response_data = json.parse(body.get_string_from_utf8())
		#var json = JSON.new()
		##var response_data = json.parse(body.get_string_from_utf8())
		#json.parse(body.get_string_from_utf8())
		#var response_data = json.get_data()
		##print("response_data")
		##print(response_data.get("data").get("player"))
		##return
#
		## Check if the parsing was successful
		#if response_data.status == "ok":
			#var data = response_data.get("data")
			##print("data!!")  # This will print the parsed dictionary
			##print(data)  # This will print the parsed dictionary
			#var player = data["player"]
			#current_player = data["player"]
			#$CanvasLayer/ContainerFull/ContainerMain/VBoxContainer/ContainerBody/HBoxContainer/ContainerSidebar1/VBoxContainer/LabelCurrentPlayer.text = "Player: " + current_player.get("username")
			##print("Player ID:", player["player_id"])
			##print("Player Name:", player["player_name"])
		#else:
			##print("Failed to parse JSON:", response_data.error_string())
			#print("Failed to parse JSON:", response_data)
#
#func _on_button_login_button_up() -> void:
	#pass
	## Get the token from the TextEditToken node
	##var token = $CanvasLayer/ContainerFull/ContainerMain/VBoxContainer/ContainerBody/HBoxContainer/ContainerSidebar1/VBoxContainer/TextEditToken.text
#
	##$MWQ.x_apiworld( {"flow": "identify", "token": token}, "", _on_identify_callback)
	#
	##mwq.x_identify()
	#
	#


func _on_button_idenify_button_up() -> void:
	mwq.x_identify()
	pass # Replace with function body.


func _on_button_home_button_up() -> void:
	#mwq.x_change_page("home.tscn")
	mwq.x_change_page("res://templates/WorldTemplate1/pages/Home.tscn", containerPage)
	pass # Replace with function body.
