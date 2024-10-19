extends Label

@export var player : Player

func _physics_process(delta: float) -> void:
	text = str(player.argent) + "  " + str(Vector2i(player.position))
