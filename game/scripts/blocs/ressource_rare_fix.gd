extends StaticBody2D


var valeur : int = 10
@export var sprite : Sprite2D 


func _ready() -> void:
	if(randi_range(0,1)==0):
		sprite.texture = ResourceLoader.load("res://assets/art/dechets/debris1.png")
		valeur = 100
	else:
		sprite.texture = ResourceLoader.load("res://assets/art/dechets/debris2.png")
		valeur = 50



var hooked : bool = false
var hook_pull : Vector2 = Vector2.ZERO



func compute_hook_pull(pull : Vector2, pullforce : int) -> void :
	hooked = true
	hook_pull = -pull.normalized() * pullforce/10



	
func _physics_process(delta: float) -> void:
	if (hooked) : 
		position += hook_pull * delta
		hooked = false


func recuperer() -> int :
	queue_free()
	return valeur
