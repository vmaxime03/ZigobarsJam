class_name ObjetInteractif
extends Hookable


@export var interactionArea : Area2D

@export var text : RichTextLabel
@export var audio : AudioStreamPlayer2D

var isAfficher : bool = false

@export var interaction_area_radius = 64

func _ready() -> void:
	var shape : CircleShape2D = (interactionArea.get_child(0) as CollisionShape2D).shape as CircleShape2D
	shape.radius = interaction_area_radius
	masquer_contenu()
	
	
func _on_interaction_area_body_entered(body: Node2D) -> void:
	get_tree().call_group("joueur", "interactive_object_area_entered", self)



func _on_interaction_area_body_exited(body: Node2D) -> void:
	get_tree().call_group("joueur", "interactive_object_area_exited", self)
	
func afficher_contenu():
	isAfficher = true
	text.show()
	audio.play(0)

func masquer_contenu():
	isAfficher = false
	text.hide()
	audio.stop()
	
