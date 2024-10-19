class_name ObjetInteractif
extends Hookable

# zone d'interaction
@export var interactionArea : Area2D

@export var text : RichTextLabel
@export var audio : AudioStreamPlayer2D

var isAfficher : bool = false

# range d 'interaction
@export var interaction_area_radius = 64

# set dynamique de la shape 
func _ready() -> void:
	var shape : CircleShape2D = (interactionArea.get_child(0) as CollisionShape2D).shape as CircleShape2D
	shape.radius = interaction_area_radius
	masquer_contenu()
	
	
# quand le joueur rentre dans la zone, le joueur est averti
func _on_interaction_area_body_entered(body: Node2D) -> void:
	get_tree().call_group("joueur", "interactive_object_area_entered", self)


# quand le joueur sort dans la zone, le joueur est averti
func _on_interaction_area_body_exited(body: Node2D) -> void:
	get_tree().call_group("joueur", "interactive_object_area_exited", self)
	

# affiche le contenu et joue la musique 
func afficher_contenu():
	isAfficher = true
	text.show()
	audio.play(0)


# affiche le contenu et joue la musique 
func masquer_contenu():
	isAfficher = false
	text.hide()
	audio.stop()
	
