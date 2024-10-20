extends AudioStreamPlayer2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.play()# Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(self.playing==false):
		get_tree().change_scene_to_file("res://scenes/mathis/test.tscn")
