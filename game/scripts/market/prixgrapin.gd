extends Label
@export var don : Donnees

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var niv = don.get_data("hook_maxdistance")
	if niv == 1000:
		text = "niveau max"
	else :
		text = str(niv * 4) + "$"
