class_name Aspirateur
extends Node2D

@export var collision_shape : CollisionPolygon2D
@export var player : Player

@export var aspirange : int = 256
@export var aspiforce : int = 50

var actif : bool = false

var aAspirer : Dictionary 

# set de la range d 'aspiration
func _ready() -> void:
	collision_shape.polygon= [Vector2.ZERO, Vector2(cos(PI/4)*aspirange, sin(PI/4)* aspirange), 
							  Vector2(aspirange, 0), Vector2(cos(-PI/4)*aspirange, sin(-PI/4)* aspirange)]


func _physics_process(delta: float) -> void:
	if (actif):
		for key in aAspirer:
			var body : Node2D = aAspirer.get(key)
			var vect : Vector2 = Vector2(body.position.x - player.position.x, body.position.y - player.position.y)
			body.position += -vect.normalized() * aspiforce * delta


func _on_aspi_body_exited(body: Node2D) -> void:
	aAspirer.erase(body.get_instance_id())


func _on_aspi_body_entered(body: Node2D) -> void:
	var n : Node2D = body
	while (is_instance_of(n.get_parent(), Node2D) and !n.is_in_group("aspirable")):
		n = n.get_parent()
	
	if (n != null and n.is_in_group("aspirable")):
		aAspirer.get_or_add(body.get_instance_id(), n)
		
	
	


func _on_collector_body_entered(body: Node2D) -> void:
	print(body.name)
	if (actif):
		var n : Node2D = body
		while (is_instance_of(n.get_parent(), Node2D) and !n.is_in_group("dechetRecuperable")):
			n = n.get_parent()
		
		if (n != null and n.is_in_group("dechetRecuperable")):
			player.argent += n.recuperer()
			
		print(n.name)


func _on_collector_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
