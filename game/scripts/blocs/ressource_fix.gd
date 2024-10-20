extends StaticBody2D



@export var valeur : int = 10
@export var sprite : Sprite2D 


func _ready() -> void:
	var rand := randi_range(0,3)
	if (rand >= 2):
		sprite.texture = ResourceLoader.load("res://assets/art/dechets/asteroidGold.png")
		valeur = 5
	elif(rand >= 1):
		sprite.texture = ResourceLoader.load("res://assets/art/dechets/asteroide2.png")
		valeur = 10
	else:
		sprite.texture = ResourceLoader.load("res://assets/art/dechets/asteroide1.png")
		valeur = 15

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
