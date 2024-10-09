extends Node
class_name MWQ

#@export var backend_url: String = "http://127.0.0.1:5000"
@export var backend_url: String = "https://myworld.quest/?action=apiworld"
@export var test_token: String = ""
@export var ISDEV: bool = false

@export var node_connector: Node
#@export var world_name: String

var current_player = {}

var wpt: String = ""
#var console = JavaScriptBridge.get_interface("console")

@export var mainurl = "https://myworld.quest/?action=apiworld"


#func flow_run(flow_name: String, params: {}, _callback_flow: Callable):
	#pass

func x_apiworld(data: Dictionary, world_player_token: String, callback: Callable):
	# Create an HTTPRequest node
	var http_request = HTTPRequest.new()
	add_child(http_request)
	
	# Connect the request_completed signal
	http_request.connect("request_completed", callback)
	
	# Set up the request data
	#var url = "https://server.com/?action=apiworld"
	#url = "http://127.0.0.1:5000/?action=apiworld"
	#url = mainurl
	var headers = ["Content-Type: application/json", "X-worldplayertoken: " + world_player_token]
	var body = data
	print("!!!", data)
	# Send the POST request
	var error = http_request.request(mainurl, headers, HTTPClient.METHOD_POST, JSON.new().stringify(body))
	
	if error != OK:
		print("Error sending request: ", error)

	pass


func x_change_page(page: String, target: Node) -> void:
	# Define the base path to the pages folder
	var base_path = "res://pages/"
	
	# Construct the full path
	var full_path = base_path + page + ".tscn"
	full_path = page
	
	# Load the scene resource
	var scene_resource = ResourceLoader.load(full_path)
	
	# Ensure the scene loaded correctly
	if scene_resource == null:
		print("Failed to load page: %s" % full_path)
		return
	
	# Instance the scene
	var new_scene = scene_resource.instantiate()
	
	# Ensure the target is a valid node
	if target == null:
		print("Target node is null")
		return

	# Clear all existing children of the target node (works for ColorRect)
	for child in target.get_children():
		child.queue_free()

	# Add the new scene to the target node
	target.add_child(new_scene)

	print("Page loaded successfully: %s" % full_path)
	
	

## Optional helper function to clear children in the target node
#func queue_free_children():
	#for child in get_children():
		#child.queue_free()


func _on_identify_callback(result, response_code, headers, body):
	print("FLOW")
	print(result)
	print(response_code)
	print(headers)
	#print(body)
	if response_code == 200:  # HTTP OK
		print("FLOW2")
		var json = JSON.new()
		json.parse(body.get_string_from_utf8())
		var response_data = json.get_data()
		print("response_data")
		print(response_data)

		# Check if the parsing was successful
		if response_data.status == "ok":
			var data = response_data.get("data")
			var player = data["player"]
			current_player = player
			print("player!")
			print(player)
			node_connector.mwq_identify_receive_data(data)
			
		else:
			#print("Failed to parse JSON:", response_data.error_string())
			print("Failed to parse JSON:", response_data)	
			#self.console.log("Failed to parse JSON:", response_data)	
			pass


func x_identify():
	# Extract the 'param' query parameter from the URL
	var wpt_value = JavaScriptBridge.eval("new URLSearchParams(window.location.search).get('wpt')")
	if ISDEV:
		#pass
		wpt_value = test_token
		#wpt_value = "97831e9a87b1ad0c5b0a6b2c9025ba77bd771217a8"
	print("!!!!!!")
	print(wpt_value)
	self.x_flow("identify",  {"token": wpt_value}, _on_identify_callback)	

func x_player_update():
	var wpt_value = JavaScriptBridge.eval("new URLSearchParams(window.location.search).get('wpt')")
	if ISDEV:
		#pass
		wpt_value = test_token
		#wpt_value = "97831e9a87b1ad0c5b0a6b2c9025ba77bd771217a8"
	print("!!!!!!")
	print(wpt_value)
	self.x_flow("player_update",  {"token": wpt_value, "position": Vector3(0, 0, 0)}, _on_identify_callback)	
	pass





func x_flow(flowname: String, params = {}, callback: Callable = self._on_request_flow_completed_default):
	var headers = [
		"Content-Type: application/json",
		#"Authorization: Bearer YOUR_API_TOKEN"  # Replace with your token if needed
	]
	var body = {
		"flow": flowname,
		"params": params
	}
	var json = JSON.new()
	var body_json = json.stringify(body)
	
	if ISDEV:
		mainurl = "http://127.0.0.1:5000/?action=apiworld"
		#pass

	
	
	var req = HTTPRequest.new()
	add_child(req)
	req.request_completed.connect(callback)
	#var err = req.request(backend_url + "/flow", headers, HTTPClient.METHOD_POST, body_json)
	var err = req.request(mainurl, headers, HTTPClient.METHOD_POST, body_json)

func _on_request_flow_completed_default(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	print("-------")
	print("_on_request_flow_completed_default")
	print(json)
	print("-------")
	pass






# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
