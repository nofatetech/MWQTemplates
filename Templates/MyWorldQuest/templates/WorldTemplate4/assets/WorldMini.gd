extends Node2D

class_name WorldMini

var url :String = ""


func set_data(rdata: Dictionary) -> void:
	$LabelTitle.text = rdata.get("title", "??")
	self.url = rdata.get("url", "")
	pass


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_enter_world_pressed() -> void:
	OS.shell_open(self.url)
	pass # Replace with function body.
