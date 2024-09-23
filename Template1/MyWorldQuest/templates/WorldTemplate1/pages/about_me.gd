extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if OS.get_name() != "HTML5":
		$ColorRect/RichTextLabel.connect("meta_clicked", self._on_RichTextLabel_meta_clicked)

	pass # Replace with function body.

func _on_RichTextLabel_meta_clicked(meta):
	OS.shell_open(meta)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
