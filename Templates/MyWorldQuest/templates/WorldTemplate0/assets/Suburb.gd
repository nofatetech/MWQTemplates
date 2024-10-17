extends Node2D

@export var scene_instance_worldmini: PackedScene

signal background_body_entered

func set_data(rdata: Dictionary) -> void:
	$LabelTitle.text = rdata.get("title", "??") + " (" + str(rdata.get("total_worlds", "?")) + ")"
	$LabelTotalWorlds.text = str(rdata.get("total_worlds", "??"))
	
	var worldminis = rdata.get("worlds", [])
	#worldminis = [
		#{
			#"id": 1,
			#"x": 1,
			#"y": 1,
			#"title": "My Test World",
		#},
	#]
#	TODO: better order of this
	var ii = 0
	for titem in worldminis:
		create_instance_worldmini(titem, ii)
		ii = ii + 1

	
	pass


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass






func create_instance_worldmini(titem: Dictionary, idx: int):
	var worldmini_name = "worldmini_" + str(titem.get("id"))
	print(">>>> worldmini_name ", worldmini_name, titem)
	var position_str = titem.get("position", null)
	
	position_str = "(" + str(idx * 150) + ", " + str(idx * 0) + ")"
	
	if null == position_str:
		position_str = "(0,0,0)"
	var tinstance = $WorldsNode.get_node(worldmini_name)
	if tinstance:
		if false: #titem.get("id") == xcurrentworldmini.get("id"):
			pass
		else:
			tinstance.position = position_from_string(position_str, 2)
	else:
		tinstance = scene_instance_worldmini.instantiate()
		tinstance.name = worldmini_name
		#print("xxx3 ", tinstance.name)
		tinstance.set_data(titem)
		#tinstance.position = Vector2(titem.get("pos_x", 10 + (idx * 130)), titem.get("pos_y", 10 + (idx * 130)))
		tinstance.position = position_from_string(position_str, 2)
		$WorldsNode.add_child(tinstance)
	#tinstance.background_body_entered.connect(worldmini_hit)

	pass

func worldmini_hit(body: Area2D):
	print("worldmini_hit")
	pass

# Function to transform a string like "(7, 7, 7)" or "(17.1, 7.1)" into a Vector2 or Vector3
# Function to transform a string into Vector2 or Vector3 based on 'vector' parameter
func position_from_string(position_str: String, vector: int) -> Variant:
	# Strip out parentheses and split by commas
	var values = position_str.strip_edges().replace("(", "").replace(")", "").split(",")

	# Convert values to floats
	var x = values[0].to_float()
	var y = values[1].to_float()

	if vector == 2:
		return Vector2(x, y)
	elif vector == 3:
		var z = values[2].to_float()
		return Vector3(x, y, z)
	
	# Default return in case of an invalid vector value
	push_error("Invalid vector size: " + str(vector))
	return Vector2.ZERO









func _on_area_2d_suburb_background_body_entered(body: Node2D) -> void:
	#print("_on_area_2d_suburb_background_body_entered")
	#$AnimationPlayer.play("background_react")
	#background_body_entered.emit()
	pass # Replace with function body.


func _on_area_2d_suburb_background_area_entered(area: Area2D) -> void:
	print("_on_area_2d_suburb_background_area_entered", area.get_parent() is Player)
	if area.get_parent() is Player:
		var tplayer :Player = area.get_parent()
		if tplayer.is_current_player:
			$AnimationPlayer.play("background_react")
			background_body_entered.emit()
			pass
		pass
	pass # Replace with function body.


func _on_area_2d_suburb_background_area_exited(area: Area2D) -> void:
	$AnimationPlayer.play("RESET")
	pass # Replace with function body.
