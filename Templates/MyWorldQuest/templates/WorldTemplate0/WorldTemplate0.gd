extends Node2D

var xcurrentplayer_node: Node
var xcurrentplayer: Dictionary = {}
@export var scene_instance_player: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MWQ.x_identify({"position": Vector3(7,7,7)})
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
