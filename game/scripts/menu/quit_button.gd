extends PanelContainer


func _ready() -> void:
	var button = Button.new()
	button.text = "Quitter"
	button.pressed.connect(self._button_pressed)
	add_child(button)
func _button_pressed():
	get_tree().quit()
