extends PanelContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var button = Button.new()
	button.text = "Play"
	button.pressed.connect(self._button_pressed)
	add_child(button)
func _button_pressed():
	get_tree().change_scene_to_file("res://scenes/debug.tscn")
