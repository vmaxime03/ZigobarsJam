class_name Hook
extends Node2D


# stats du grapin
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



# supprimer le grapin 
func delete():
	rope.queue_free()
	queue_free()

# recuperer le vecteur du joueur au grapin
func get_vector() -> Vector2 :
	var p0 : Vector2 =  rope.get_point_position(0)
	var p1 : Vector2 =  rope.get_point_position(1)

	return Vector2(p1.x - p0.x, p1.y - p0.y)


# recupere la tension : distance / distancemax 
func get_tension() -> float :
	return distance / maxdistance


# ready
func _ready() -> void:
	position = player.position
	
	rope =  Line2D.new()
	rope.width = 1
	rope.add_point(player.position, 0)
	rope.add_point(position, 1)
	
	vel = Vector2(player.mousePos.x - player.position.x, player.mousePos.y - player.position.y).normalized() * speed


# physique 
func _physics_process(delta: float) -> void : 

	# actualiser le point du joueur
	rope.set_point_position(0, player.position)	
	distance = player.position.distance_to(position)
	
	# si le grapin n'est pas acrocher, il avance 
	if (!fixed):
		position += vel * delta

		sprite.rotation = vel.angle() + PI/2

		rope.set_point_position(1, position)
		
		if (distance > maxdistance) :
			delete()
	# si l'objet est attirable, actualise le point du grapin
	else : 
		if (pullable) : 
			position = to_global(fixedOn.position)/2
		rope.set_point_position(1, position)

		# rotation de la point par rapport au joueur
		sprite.rotation = player.position.angle_to_point(position) + PI/2

	
		
# quand le grapin entre en colision avec un objet 
func _on_area_2d_body_entered(body: Node2D) -> void:
	if (!fixed):
		# on recupere l'objet avec qui il colisionne 
		fixed = true
		fixedOn = body

		# on cherche si l'objet a un parent hookable
		var n : Node = body
		while (n != null and !n.is_in_group("hookable")):
			n = n.get_parent()
					
		# si oui, on indique l'objet pullable et on met l'objet hookablke a fixedOn
		if (n != null and n.is_in_group("hookable")) :
			pullable = true
			fixedOn = n
	
