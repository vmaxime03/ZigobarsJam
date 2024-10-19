class_name Hookable
extends Node2D

var hooked : bool = false
var hook_pull : Vector2 = Vector2.ZERO

func compute_hook_pull(pull : Vector2, pullforce : int) -> void :
    hooked = true
    hook_pull = -pull.normalized() * pullforce/10

func hook_pull_physics(delta : float):
    if (hooked) : 
        position += hook_pull
        hooked = false

    
func _physics_process(delta: float) -> void:
    hook_pull_physics(delta)

    