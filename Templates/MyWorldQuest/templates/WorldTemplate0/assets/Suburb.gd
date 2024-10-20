extends Node2D

@export var scene_instance_worldmini: PackedScene
@export var scene_instance_emptyworldmini: PackedScene

signal background_body_entered

@onready var emties_node = $EmtiesNode2D  # Reference to the parent node where the ColorRects will be added



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


# Function to create a grid of Sprites (ColorRect equivalent)
func create_colorrect_grid(x_size: int, y_size: int):
	var rect_size = Vector2(500, 500)
	
	for y in range(y_size):
		for x in range(x_size):
			#pass
			
			create_instance_empty_worldmini(x, y)
			
			## Create a new Sprite2D node
			#var sprite = Sprite2D.new()
#
			## Create a rectangle texture with white color and 50% transparency
			#var image = Image.new()
			#image.create(rect_size.x, rect_size.y, false, Image.FORMAT_RGBA8)
			#image.fill(Color(1, 1, 1, 0.9))  # White color with 50% transparency
			#var texture = ImageTexture.create_from_image(image)
#
			## Assign the texture to the sprite
			#sprite.texture = texture
#
			## Position the sprite in the grid
			#sprite.position = Vector2(x * rect_size.x, y * rect_size.y)
			#print("!!!! ", sprite.position)
#
			## Add the sprite as a child to the EmtiesNode2D node
			#emties_node.add_child(sprite)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_colorrect_grid(5, 5)  # Adjust the X and Y grid size here

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func create_instance_empty_worldmini(x: int, y: int):
	#pass
	var emptyworldmini_name = "emptyworldmini_" + str(x)+ "-" + str(x)  #str(titem.get("id"))
	print(">>>> emptyworldmini_name ", emptyworldmini_name)
	var position_str = "(" + str(x * 150) + ", " + str(y * 0) + ")"
	
	if null == position_str:
		position_str = "(0,0,0)"
	var tinstance = $EmtiesNode2D.get_node(emptyworldmini_name)
	if tinstance:
		if false: #titem.get("id") == xcurrentemptyworldmini.get("id"):
			pass
		else:
			tinstance.position = position_from_string(position_str, 2)
	else:
		tinstance = scene_instance_emptyworldmini.instantiate()
		tinstance.name = emptyworldmini_name
		#print("xxx3 ", tinstance.name)
		#tinstance.set_data(titem)
		#tinstance.position = Vector2(titem.get("pos_x", 10 + (idx * 130)), titem.get("pos_y", 10 + (idx * 130)))
		tinstance.position = position_from_string(position_str, 2)
		$EmtiesNode2D.add_child(tinstance)




func create_instance_worldmini(titem: Dictionary, idx: int):
	var worldmini_name = "worldmini_" + str(titem.get("id"))
	print(">>>> worldmini_name ", worldmini_name, titem)
	var position_str = titem.get("position", null)
	
	position_str = "(" + str(idx * 250) + ", " + str(idx * 0) + ")"
	
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
