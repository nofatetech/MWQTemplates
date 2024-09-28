extends Node

# Assuming you have a Label for title, a RichTextLabel for content, and a Label for summary.
@export var title_label: Label
@export var content_label: RichTextLabel
@export var summary_label: Label

# Set the post data to the UI elements
func set_data(post_data: Dictionary) -> void:
	title_label.text = post_data.get("title", "No Title")
	content_label.text = post_data.get("content", "No Content")
	summary_label.text = post_data.get("summary", "No Summary")
