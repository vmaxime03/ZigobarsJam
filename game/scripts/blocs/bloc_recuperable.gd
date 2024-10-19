extends StaticBody2D


@export var valeur : int = 10

func recuperer() -> int :
	queue_free()
	return valeur
