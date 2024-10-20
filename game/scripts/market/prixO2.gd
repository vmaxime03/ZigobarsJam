extends Label
@export var don : Donnees

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var niv = don.get_data("maxo2")
	if niv == 600:
		text = "niveau max"
	else :
		text = str(niv * 5) + "$"
