extends Node2D

class_name Hood

@export var scene_instance_suburb: PackedScene


func set_data(rdata: Dictionary) -> void:
	$LabelTitle.text = rdata.get("title", "??")
	
	
	var suburbs = rdata.get("suburbs", [])
#	TODO: better order of this
	var ii = 0
	for sub in suburbs:
		create_instance_suburb(sub, ii)
		ii = ii + 1

	pass



func create_instance_suburb(titem: Dictionary, idx: int):
	var suburb_name = "suburb_" + str(titem.get("id"))
	#print(">>>> suburb_name ", suburb_name, titem)
	var position_str = titem.get("position", null)
	
	position_str = "(" + str(idx * 3333) + ", " + str(idx * 0) + ")"
	
	if null == position_str:
		position_str = "(0,0,0)"
	var tinstance = $SuburbsNode.get_node(suburb_name)
	if tinstance:
		if false: #titem.get("id") == xcurrentsuburb.get("id"):
			pass
		else:
			tinstance.position = position_from_string(position_str, 2)
	else:
		tinstance = scene_instance_suburb.instantiate()
		tinstance.name = suburb_name
		#print("xxx3 ", tinstance.name)
		tinstance.set_data(titem)
		#tinstance.position = Vector2(titem.get("pos_x", 10 + (idx * 130)), titem.get("pos_y", 10 + (idx * 130)))
		tinstance.position = position_from_string(position_str, 2)
		$SuburbsNode.add_child(tinstance)
	tinstance.background_body_entered.connect(suburb_hit)

	pass

func suburb_hit(body: Area2D):
	print("suburb_hit")
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



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
