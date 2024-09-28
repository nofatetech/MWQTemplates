extends Node
class_name MWQ_Wordpress

@export var wp_api_url: String = "https://yourwordpresssite.com/wp-json/wp/v2/posts"
@export var posts_per_page: int = 10
@export var wp_post_scene: PackedScene # Scene for each post (which contains WpPost.gd logic)

# Variables to track pagination
var current_page: int = 1
var total_pages: int = 1

func _ready() -> void:
	# Start by loading the first page of posts
	load_posts(current_page)

# Function to fetch the posts from the WordPress API
func load_posts(page: int) -> void:
	var url := wp_api_url + "?page=" + str(page) + "&per_page=" + str(posts_per_page)
	var request := HTTPRequest.new()
	add_child(request)

	request.request_completed.connect(self._on_request_completed)
	request.request(url)

# Callback when the HTTPRequest is completed
func _on_request_completed(result: int, response_code: int, headers: Array, body: PackedByteArray) -> void:
	if response_code == 200:
		var json = JSON.new()
		var json_data = json.parse(body.get_string_from_utf8())
		
		if json_data.error == OK:
			var posts = json_data.result

			# Loop through each post and instantiate WpPost objects
			for post in posts:
				var wp_post_node := wp_post_scene.instantiate()
				#if wp_post_node is WpPost:
					## Extract necessary data from the post
					#var post_data = {
						#"title": post.get("title").get("rendered", "No Title"),
						#"content": post.get("content").get("rendered", "No Content"),
						#"summary": post.get("excerpt").get("rendered", "No Summary")
					#}
					## Set the data on the WpPost node
					#wp_post_node.set_data(post_data)
#
					## Add the WpPost node to the scene (you can use a container like VBoxContainer)
					#add_child(wp_post_node)

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
