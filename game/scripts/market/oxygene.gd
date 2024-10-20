extends Button
@export var don : Donnees

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	var niv = don.get_data("maxo2")
	if niv != 600:
		var cout = niv * 5
		if cout <= don.get_data("argent"):
			don.set_data("argent", don.get_data("argent")-cout)
			don.set_data("maxo2", don.get_data("maxo2") + 100)
		else: 
			text = "pas assez money"
