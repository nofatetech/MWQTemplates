extends Node2D

# Assuming 'filterObject' is a custom control (could be a Panel or any UI element)
class_name FilterObject
# For this example, 'FilterObject' just contains a Label for the title
@export var label: Label
@export var shadow_label: Label
@export var emoji_label: Label

func setdata(title: Dictionary):
	#print("setdata " + title)
	#label = Label.new()
	label.text = title.get("title")
	shadow_label.text = title.get("title")
	emoji_label.text = title.get("emoji")
	#%FilterGrid.add_child(label)
