extends Node2D

@export var scene_instance_player: PackedScene
@export var whoami: Dictionary = {}

var dynamyc_node_camera2d: Node = null  # Variable to store the reference to the changing node

var tcurrentplayer: Node = null



func mwq_receive_player(player: Dictionary):
	print("mwq_receive_player")
	print(mwq_receive_player)
	%LabelPlayerUsername.text = player.username
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MWQ.x_identify()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
