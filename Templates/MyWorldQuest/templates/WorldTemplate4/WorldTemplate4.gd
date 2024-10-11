extends Node2D

@export var wp_api_url: String = "https://yourwordpresssite.com/wp-json/wp/v2/posts"
@export var posts_per_page: int = 10
@export var wp_post_scene: PackedScene # Scene for each post (which contains WpPost.gd logic)
@export var wp_post_parent_node: Node # Scene for each post (which contains WpPost.gd logic)
@export var jobdb_category_id: int = 123
@export var dynamyc_node_camera2d: Node = null  # Variable to store the reference to the changing node
#@export	var api_main_url := "http://myworld.quest"
@export var FilterObject: PackedScene
@export var FiltersNode2d: Node2D

# Variables to track pagination
var current_page: int = 1
var total_pages: int = 1
var xcurrentplayer_node: Node
var xcurrentplayer: Dictionary = {}

@export var scene_instance_player: PackedScene


# List of filters with emojis
var filter_titles = [
	{"emoji": "🤓", "title":"Engineer"},
	{"emoji": "💼", "title":"Executive"},
	{"emoji": "👵", "title":"Senior"},
	{"emoji": "🤓", "title":"Developer"},
	{"emoji": "💰", "title":"Finance"},
	{"emoji": "♾️", "title":"Sys Admin"},
	{"emoji": "☕️", "title":"JavaScript"},
	{"emoji": "🍑", "title":"Backend"},
	{"emoji": "🐀", "title":"Golang"},
	{"emoji": "☁️", "title":"Cloud"},
	{"emoji": "🚑", "title":"Medical"},
	{"emoji": "🎨", "title":"Front End"},
	{"emoji": "🥞", "title":"Full Stack"},
	{"emoji": "♾️", "title":"Ops"},
	{"emoji": "🎨", "title":"Design"},
	{"emoji": "⚛️", "title":"React"},
	{"emoji": "🔑", "title":"InfoSec"},
	{"emoji": "🚥", "title":"Marketing"},
	{"emoji": "📱", "title":"Mobile"},
	{"emoji": "✍️", "title":"Content Writing"},
	{"emoji": "📦", "title":"SaaS"},
	{"emoji": "🎯", "title":"Recruiter"},
	{"emoji": "⏰", "title":"Full Time"},
	{"emoji": "🤖", "title":"API"},
	{"emoji": "💼", "title":"Sales"},
	{"emoji": "💎", "title":"Ruby"},
	{"emoji": "👨‍🏫", "title":"Education"},
	{"emoji": "♾️", "title":"DevOps"},
	{"emoji": "👩‍🔬", "title":"Stats"},
	{"emoji": "🐍", "title":"Python"},
	{"emoji": "🔗", "title":"Node"},
	{"emoji": "🇬🇧", "title":"English"},
	{"emoji": "🔌", "title":"Non Tech"},
	{"emoji": "📼", "title":"Video"},
	{"emoji": "🎒", "title":"Travel"},
	{"emoji": "🔬", "title":"Quality Assurance"},
	{"emoji": "🛍", "title":"Ecommerce"},
	{"emoji": "👨‍🏫", "title":"Teaching"},
	{"emoji": "🐧", "title":"Linux"},
	{"emoji": "☕️", "title":"Java"},
	{"emoji": "🏅", "title":"Crypto"},
	{"emoji": "👶", "title":"Junior"},
	{"emoji": "📦", "title":"Git"},
	{"emoji": "👩‍⚖️", "title":"Legal"},
	{"emoji": "🤖", "title":"Android"},
	{"emoji": "💼", "title":"Accounting"},
	{"emoji": "♾️", "title":"Admin"},
	{"emoji": "🖼", "title":"Microsoft"},
	{"emoji": "📗", "title":"Excel"},
	{"emoji": "🐘", "title":"PHP"},
	{"emoji": "☁️", "title":"Amazon"},
	{"emoji": "☁️", "title":"Serverless"},
	{"emoji": "🎨", "title":"CSS"},
	{"emoji": "🤓", "title":"Software"},
	{"emoji": "🤔", "title":"Analyst"},
	{"emoji": "🅰️", "title":"Angular"},
	{"emoji": "🍏", "title":"iOS"},
	{"emoji": "🎧", "title":"Customer Support"},
	{"emoji": "🔡", "title":"HTML"},
	{"emoji": "☁️", "title":"Salesforce"},
	{"emoji": "🚥", "title":"Ads"},
	{"emoji": "📦", "title":"Product Designer"},
	{"emoji": "👋", "title":"HR"},
	{"emoji": "🐬", "title":"SQL"},
	{"emoji": "🔷", "title":"C"},
	{"emoji": "🤓", "title":"Web Developer"},
	{"emoji": "🚫", "title":"NoSQL"},
	{"emoji": "🐬", "title":"Postgres"},
	{"emoji": "➕", "title":"C Plus Plus"},
	{"emoji": "⏰", "title":"Part Time"},
	{"emoji": "🔷", "title":"Jira"},
	{"emoji": "#️⃣", "title":"C Sharp"},
	{"emoji": "🔎", "title":"SEO"},
	{"emoji": "🚁", "title":"Apache"},
	{"emoji": "👩‍🔬", "title":"Data Science"},
	{"emoji": "🎧", "title":"Virtual Assistant"},
	{"emoji": "⚛️", "title":"React Native"},
	{"emoji": "🍃", "title":"Mongo"},
	{"emoji": "🧪", "title":"Testing"},
	{"emoji": "📦", "title":"Architecture"},
	{"emoji": "🔷", "title":"Director"},
	{"emoji": "🎵", "title":"Music"},
	{"emoji": "🛍", "title":"Shopify"},
	{"emoji": "✍️", "title":"Wordpress"},
	{"emoji": "🧩", "title":"Elasticsearch"},
	{"emoji": "⛓", "title":"Blockchain"},
	{"emoji": "💎", "title":"Web3"},
	{"emoji": "💧", "title":"Drupal"},
	{"emoji": "🐳", "title":"Docker"},
	{"emoji": "⚛️", "title":"GraphQL"},
	{"emoji": "💼", "title":"Payroll"},
	{"emoji": "👩‍🎓", "title":"Internship"},
	{"emoji": "🤖", "title":"Machine Learning"},
	{"emoji": "📦", "title":"Architect"},
	{"emoji": "☕️", "title":"Scala"},
	{"emoji": "🎨", "title":"Web"},
	{"emoji": "🍏", "title":"Objective C"},
	{"emoji": "✍️", "title":"Social Media"},
	{"emoji": "💚", "title":"Vue"},
]



func _ready() -> void:
	# Start by loading the first page of posts
	load_posts(current_page)
#	# Identify with MWQ
	$MWQ.x_identify({"position": Vector3(7,7,7)})
	
	# Create filter objects
	var ii = 0
	for title in filter_titles:
		# Instantiate the custom FilterObject
		var filter_obj = FilterObject.instantiate()
		filter_obj.setdata(title) # Set the title for the filter
		
		# Calculate row and column for a grid layout (10 per row)
		var column = ii % 10  # Modulus to get the column (0-9)
		var row = ii / 10  # Integer division to get the row
		
		# Set the position based on column and row
		filter_obj.position = Vector2(1000 * column, 1333 * row)
		
		# Add the filter object to the parent node
		FiltersNode2d.add_child(filter_obj)
		
		# Increment the counter
		ii += 1

	# Create a Timer node if it's not added in the scene
	var timer = Timer.new()
	timer.wait_time = 3.0  # Set the timer interval to 3 seconds
	timer.autostart = true  # Start the timer automatically
	timer.one_shot = false  # Make sure it repeats
	add_child(timer)  # Add the timer to the scene

	# Connect the timeout signal to a custom function
	timer.timeout.connect(cronnn)

# Function that will be called every 3 seconds
func cronnn():
	print("This runs every 3 seconds")
	print("cronnn")
	#$MWQ.x_identify({"position": Vector3(7,7,7)})
	$MWQ.x_identify({"position": xcurrentplayer_node.position})
	pass



func mwq_identify_receive_data(data):
	xcurrentplayer = data.get("player", {})
	var all_players_here = data.get("all_players_here", [])
	#var ii = 0
	#for player in all_players_here:
		#ii = ii + 1
		#if $PlayersNode.node_exists("player_" + player.get("username")):
			#playerobj.position = position_from_string(player.get("position"))
		#else:
			#create_instance_player(player, ii, name="player_" + player.get("username"))
	#pass
	var ii = 0
	for player in all_players_here:
		ii += 1  # Simplified increment
		
		create_instance_player(player, ii)

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




func create_instance_player(titem: Dictionary, idx: int):
	var player_name = "player_" + str(titem.get("id"))
	print(">>>> player_name ", player_name, titem)
	var position_str = titem.get("position", null)
	if null == position_str:
		position_str = "(0,0,0)"
	var tinstance = $PlayersNode.get_node(player_name)
	if tinstance:
		if titem.get("id") == xcurrentplayer.get("id"):
			pass
		else:
			tinstance.position = position_from_string(position_str, 2)
	else:
		tinstance = scene_instance_player.instantiate()
		tinstance.name = player_name
		print("xxx3 ", tinstance.name)
		tinstance.set_data(titem)
		#tinstance.position = Vector2(titem.get("pos_x", 10 + (idx * 130)), titem.get("pos_y", 10 + (idx * 130)))
		tinstance.position = position_from_string(position_str, 2)
		$PlayersNode.add_child(tinstance)
		#tinstance.title = titem.get("title", "??")
		##tinstance.title = titem.get("title", {}).get("rendered", "Unknown title")
		##tinstance.position = Vector2(titem.get("x", 0), titem.get("y", 0))
		#tinstance.id = titem.get("id", 0)
		#tinstance.position = Vector2(100, 100 + (idx * 133))
		#tinstance.position = Vector2(10 + (idx * 130), 10 + (idx * 130))
		#tinstance.redraw()
		#print("item id: ", tinstance.id)
		
		#var image_path = titem.get("image", "")
		#image_path = "res://icon.svg"
		#if image_path != "":
			#var texture = load(image_path)
			##if texture:
				##tinstance.titem_image = texture

		if self.xcurrentplayer and self.xcurrentplayer.get("username", "") == titem.username:
			xcurrentplayer_node = tinstance
			print("ITS ME! ", self.xcurrentplayer.username)
			tinstance.is_current_player = true
			dynamyc_node_camera2d.reparent(tinstance)
			#tinstance.hit.connect(my_player_hit)
			#tinstance.leave.connect(my_player_leave)
			pass



	

func my_player_hit(area: Area2D):
	#if area.name == "Area2DBusinessLobby":
		#print("HIT Business: " + area.get_parent().__name)
		#var anim: AnimationPlayer = xcurrentplayer.get()
		#anim.play("supersign")
		#print(anim)
		#pass
	print("---" )

func my_player_leave(area: Area2D):
	#if area.name == "Area2DBusinessLobby":
		#print("Leaving Business: " + area.get_parent().__name)
		#var anim: AnimationPlayer = xcurrentplayer.get()
		#anim.seek(0, true)
		##print(anim)
		#pass
	print("---" )



# Function to fetch the posts from the WordPress API
# Category ID for "JobDB" (replace with the actual category ID)

func load_posts(page: int) -> void:
	var url := wp_api_url + "?page=" + str(page) + "&per_page=" + str(posts_per_page) + "&categories=" + str(jobdb_category_id) + "&_embed=tags"
	
	var request := HTTPRequest.new()
	add_child(request)

	request.request_completed.connect(self._on_load_posts_request_completed)
	request.request(url)

# Callback when the HTTPRequest is completed
func _on_load_posts_request_completed(result: int, response_code: int, headers: Array, body: PackedByteArray) -> void:
	#print("load")
	#print(response_code)
	if response_code == 200:
		var json = JSON.new()
		#var json_data = json.parse(body.get_string_from_utf8())
		json.parse(body.get_string_from_utf8())
		var json_data = json.get_data()
		
		if true: #json_data.error == OK:
			var posts = json_data#.result

			## Loop through each post and instantiate WpPost objects
			#for post in posts:
				#print(post.get("title").get("rendered"))
				#print(post.get("class_list"))
				#var wp_post_node := wp_post_scene.instantiate()
				#if true: # wp_post_node is WpPost:
					## Extract necessary data from the post
					#var post_data = {
						#"title": post.get("title").get("rendered", "No Title"),
						#"content": post.get("content").get("rendered", "No Content"),
						#"summary": post.get("excerpt").get("rendered", "No Summary")
					#}
					## Set the data on the WpPost node
					#wp_post_node.set_data(post_data)
					#print(post_data)

			for post in posts:
				var tags: Array = post.get("class_list", [])

				# If the post contains a "job" related tag, instantiate the WpPost node
				if true: #has_job_tag:
					var wp_post_node := wp_post_scene.instantiate()
					if true: #wp_post_node is WpPost:
						# Extract necessary data from the post
						var post_data = {
							"title": post.get("title").get("rendered", "No Title"),
							"content": post.get("content").get("rendered", "No Content"),
							"summary": post.get("excerpt").get("rendered", "No Summary"),
							"tags": tags,
							#"main_image": "https://myworld.quest/static/uploads/PT_GXk4PV5aMAA8PnB.jpg",
						}
						print("post_data")
						print(post_data.get("title"))
						print(post_data.get("tags"))
						# Set the data on the WpPost node
						wp_post_node.set_data(post_data)

						# Add the WpPost node to the scene (you can use a container like VBoxContainer)

	#pass # Replace with function body.

			# Example: get total number of pages from response headers (for pagination)
			for header in headers:
				if header.begins_with("X-WP-TotalPages"):
					total_pages = int(header.split(":")[1].strip_edges())

			# If there are more pages, load the next one (you can add a button or automatic pagination)
			if current_page < total_pages:
				current_page += 1
				load_posts(current_page)
	else:
		print("Error fetching posts, response code:", response_code)


func _on_zoomout_button_down() -> void:
	print("zoom out!!1 ", dynamyc_node_camera2d.zoom)
	dynamyc_node_camera2d.zoom = dynamyc_node_camera2d.zoom * 0.9
	print("zoom out!!2 ", dynamyc_node_camera2d.zoom)


func _on_zoomin_button_down() -> void:
	dynamyc_node_camera2d.zoom = dynamyc_node_camera2d.zoom * 1.1
	pass # Replace with function body.
