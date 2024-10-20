class_name Hookable
extends Node2D


#Pour les objet attirable par le grapin

var hooked : bool = false
var hook_pull : Vector2 = Vector2.ZERO



func compute_hook_pull(pull : Vector2, pullforce : int) -> void :
	hooked = true
	hook_pull = -pull.normalized() * pullforce/10



	
func _physics_process(delta: float) -> void:
	if (hooked) : 
		position += hook_pull * delta
		hooked = false

	
