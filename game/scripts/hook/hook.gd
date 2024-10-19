class_name Hook
extends Node2D



@export var speed : Vector2 = Vector2(500,500)

@export var player : Node2D

@export var rope : Line2D 
@export var maxdistance : int = 500

@export var sprite : Sprite2D

var vel : Vector2

@export var fixed : bool = false
@export var pullable : bool = false

var fixedOn : Node2D = null

var distance : float = 0

func delete():
	rope.queue_free()
	queue_free()

func get_vector() -> Vector2 :
	var p0 : Vector2 =  rope.get_point_position(0)
	var p1 : Vector2 =  rope.get_point_position(1)

	return Vector2(p1.x - p0.x, p1.y - p0.y)

func get_tension() -> float :
	return distance / maxdistance

func _ready() -> void:
	position = player.position
	
	rope =  Line2D.new()
	rope.width = 1
	rope.add_point(player.position, 0)
	rope.add_point(position, 1)
	
	vel = Vector2(player.mousePos.x - player.position.x, player.mousePos.y - player.position.y).normalized() * speed


func _physics_process(delta: float) -> void : 

	rope.set_point_position(0, player.position)
	
	distance = player.position.distance_to(position)
	
	if (!fixed):
		position += vel * delta

		sprite.rotation = vel.angle() + PI/2

		rope.set_point_position(1, position)
		
		if (distance > maxdistance) :
			delete()
	
	else : 
		if (pullable) : 
			position = to_global(fixedOn.position)/2
		rope.set_point_position(1, position)

		sprite.rotation = player.position.angle_to_point(position) + PI/2

	
		

func _on_area_2d_body_entered(body: Node2D) -> void:
	fixed = true
	fixedOn = body
	
	var n : Node = body
	
	while (n != null and !n.is_in_group("hookable")):
		n = n.get_parent()
				
	if (n != null and n.is_in_group("hookable")) :
		pullable = true
		fixedOn = n
	
	print(position - fixedOn.position)
