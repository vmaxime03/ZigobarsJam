extends Button


func _ready() -> void:
	self.text = "Quitter"
	self.pressed.connect(self._button_pressed)
func _button_pressed():
	get_tree().change_scene_to_file("res://scenes/debug.tscn")
