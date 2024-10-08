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


# List of filters with emojis as titles
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
	#load_posts(current_page)
	$MWQ.x_identify()
	
	# Create filter objects and add to the grid
	var ii = 0
	for title in filter_titles:
		# Instantiate the custom FilterObject
		var filter_obj = FilterObject.instantiate()
		filter_obj.setdata(title) # Set the title for the filter
		filter_obj.position = Vector2(0, 0 + (333 * ii))
		FiltersNode2d.add_child(filter_obj)
		ii += 1

	
	pass

func mwq_identify_receive_data(data):
	print("mwq_identify_receive_data")
	#print(data.get("all_players_here"))
	
	
	
	xcurrentplayer = data.get("player", {})
	var all_players_here = data.get("all_players_here", [])
	var ii = 0
	for player in all_players_here:
		ii = ii + 1
		create_instance_player(player, ii)
	pass

func create_instance_player(titem: Dictionary, idx: int):
	var tinstance = scene_instance_player.instantiate()
	tinstance.set_data(titem)
	$PlayersNode.add_child(tinstance)
	#var whoami = titem.get("whoami", null)
	#print("whoami")
	#print(whoami)
	if self.xcurrentplayer and self.xcurrentplayer.get("username", "") == titem.username:
		print("ITS ME! ", self.xcurrentplayer.username)
		tinstance.is_current_player = true
		#tinstance.hit.connect(my_player_hit)
		#tinstance.leave.connect(my_player_leave)
#
		##tinstance.name
		dynamyc_node_camera2d.reparent(tinstance)
		print("CAMERA MOVW")
		pass
	#tinstance.title = titem.get("title", "??")
	##tinstance.title = titem.get("title", {}).get("rendered", "Unknown title")
	##tinstance.position = Vector2(titem.get("x", 0), titem.get("y", 0))
	#tinstance.id = titem.get("id", 0)
	#tinstance.position = Vector2(100, 100 + (idx * 133))
	#tinstance.position = Vector2(10 + (idx * 130), 10 + (idx * 130))
	tinstance.position = Vector2(titem.get("pos_x", 10 + (idx * 130)), titem.get("pos_y", 10 + (idx * 130)))
	#tinstance.redraw()
	#print("item id: ", tinstance.id)
	
	#var image_path = titem.get("image", "")
	#image_path = "res://icon.svg"
	#if image_path != "":
		#var texture = load(image_path)
		##if texture:
			##tinstance.titem_image = texture
	

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
	dynamyc_node_camera2d.zoom = dynamyc_node_camera2d.zoom * 0.9


func _on_zoomin_button_down() -> void:
	dynamyc_node_camera2d.zoom = dynamyc_node_camera2d.zoom * 1.1
	pass # Replace with function body.
