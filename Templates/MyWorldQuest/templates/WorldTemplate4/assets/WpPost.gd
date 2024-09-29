extends Node

# Assuming you have a Label for title, a RichTextLabel for content, and a Label for summary.
@export var title_label: Label
@export var content_label: RichTextLabel
@export var summary_label: Label
@export var tags_label: RichTextLabel
@onready var image_texture_rect = $"TextureRect" # Change this path to match your scene setup
@onready var http_request = HTTPRequest.new()

func set_data(post_data: Dictionary) -> void:
	title_label.text = post_data.get("title", "No Title")
	content_label.text = post_data.get("content", "No Content")
	summary_label.text = post_data.get("summary", "No Summary")
	
	# Load tags as before
	var tags: Array = post_data.get("tags", [])
	var job_tags: Array = []

	for tag in tags:
		if str(tag).begins_with("tag-job_"):
			job_tags.append(tag.replace("tag-job_", ""))

	var tags_string: String = " // ".join(job_tags) if job_tags.size() > 0 else "No Job Tags"
	tags_label.bbcode_text = "[b]Tags:[/b] " + tags_string

	## Load the image from the main_image URL
	#var image_url: String = post_data.get("main_image", "")
	#if image_url != "":
		#load_image_from_url(image_url)

# Function to load the image from the given URL
func load_image_from_url(url: String) -> void:
	return
	pass
	# Add HTTPRequest as a child node (if it's not already part of the scene)
	if not http_request.is_inside_tree():
		add_child(http_request)

	# Connect the request_completed signal to handle the response
	#http_request.connect("request_completed", self, "_on_image_request_completed")
	http_request.request_completed.connect(self._on_image_request_completed)


	http_request.request(url)

# Handle the image download response
func _on_image_request_completed(result: int, response_code: int, headers: Array, body) -> void:
	if response_code == 200:
		var image = Image.new()
		var err = image.load_png_from_buffer(body)
		if err == OK:
			var texture = ImageTexture.new()
			texture.create_from_image(image)
			image_texture_rect.texture = texture  # Set the texture to the TextureRect
	else:
		print("Failed to load image from URL: " + str(response_code))
