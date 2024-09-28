extends Node2D

@export var scene_instance_player: PackedScene
@export var whoami: Dictionary = {}

var dynamyc_node_camera2d: Node = null  # Variable to store the reference to the changing node

var tcurrentplayer: Node = null
var all_players_here: Array = []


func mwq_identify_receive_data(data: Dictionary):
	print("mwq_identify_receive_data")
	print(data)
	whoami = data.get("player")
	all_players_here = data.get("all_players_here")
	%LabelPlayerUsername.text = whoami.username
	# Create an empty string to store the usernames
	var usernames = "Other players here:\n\n"
	
	# Loop through each player object in the list and append their username
	for player in all_players_here:
		usernames += player["username"] + "\n"  # Add each username on a new line
	
	# Set the label's text to the list of usernames
	%LabelOtherPlayersHere.text = usernames
	
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MWQ.x_identify()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
