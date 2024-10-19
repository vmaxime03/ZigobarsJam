class_name Player
extends CharacterBody2D

# ajout export pour l'inscpecteur
@export_group("UPGRADES")
@export_subgroup("SKILLS")
@export var hook_enable : bool = true
@export var dash_enable : bool = true

@export_subgroup("STATS")
@export var BASE_SPEED : Vector2  = Vector2(300, 300)
@export var HOOK_PULL_FORCE : int = 10
@export var maxpower : int = 10
@export var minpower : int = 1
@export var carb : int = 100
@export var dashBaseCD : int = 5
@export var dashCost : int = 30
@export var DASH_VELOCITY : Vector2 = Vector2(300, 300)



@export_group("AFFICHAGE STATS")
@export var carbBar : TextureProgressBar
@export var interactButton : Button


@onready var power : int = minpower

@export_group("SCENE")
@export var body : Sprite2D
@export var arm : Sprite2D

@export var animation_tree : AnimationTree
@onready var state_machine : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")

var isObjetInteractifProche : bool = false
var objetInteractifProche : ObjetInteractif = null

#scene de grappin pour instantation
var hookScene = preload("res://scenes/hook.tscn")
var hook : Hook


@onready var dashCD : int = 0


# update la barre de carburant
func _update_carb_bar() -> void :
	carbBar.value = carb

# TODO barre d'oxygene 

# on ready
func _ready() -> void:
	carbBar.max_value = carb
	
	interactButton.hide()


# vecteur recuperer a chaque execution 
var mousePos : Vector2
var vel : Vector2
var dir : Vector2

func _physics_process(delta: float) -> void:
	mousePos = get_global_mouse_position()
	vel = velocity

	# touche pressee
	dir = Input.get_vector("q", "d", "z", "s")
	
	# puissance du moteur (temps de pressage de la touche)
	var p : float = 2 * (float(power) / maxpower )
	
	if (dir != Vector2.ZERO):
		# deplacer le perso
		vel += dir * BASE_SPEED * delta * p
		if (power < maxpower):
			power += 1
		carb -= 1

		# jouer l'animation
		state_machine.travel("move")
	else:
		if (power > minpower): 
			power-= 1

		# jouer l'animation
		state_machine.travel("idle")
	
	#TODO freinage


	
	# gere l'interaction avec les objets interactifs
	interact_action()
	
	# si le grapin est deverouiller gere le grappin
	if (hook_enable):
		# gere l'action d'envoyer le grapin
		hook_action()
		# gere l'action du grapin sur la physique de personage 
		hook_physics()
	
	# si le dash est deverouiller, gere l'action du dash
	if (dash_enable):
		dash_action()
	
	# actualiser la barre de carburant
	_update_carb_bar()
	
	# on gere les rotation des sprite en fonction de la souris et de la velocité
	arm.rotation = atan2(mousePos.y - position.y, mousePos.x - position.x)
	body.rotation = vel.angle() 
	
	#deplacement 
	velocity = vel
	move_and_slide()
	

# action dash
func dash_action():
	if (Input.is_action_just_pressed("space")) :
		if (dashCD <= 0 and carb >= dashCost) : 
			print("dash")
			dashCD = dashBaseCD
			carb -= dashCost
			vel += DASH_VELOCITY * dir.normalized()
			state_machine.travel("dash")
		else :
			if (dashCD > 0) : dashCD-= 1
			#TODO son de manque de ressource

		

# action de l'interaction, si dans la range de l'objet, active la possibiliter d'etendre l affichage
func interact_action():
	if (isObjetInteractifProche) :
		interactButton.show()
		if Input.is_action_just_pressed("e"):
			if (objetInteractifProche.isAfficher):
				objetInteractifProche.masquer_contenu()
			else :
				objetInteractifProche.afficher_contenu()
	else :
		interactButton.hide()
		if (objetInteractifProche) :  objetInteractifProche.masquer_contenu()


# action d'envoyer le grapin
func hook_action() -> void:
	if (Input.is_action_just_pressed("l_click")):
		hook = hookScene.instantiate()
		hook.player = self
		get_tree().root.add_child(hook)
		get_tree().root.add_child(hook.rope)
		
	if (Input.is_action_just_released("l_click")):
		if (hook != null) : hook.delete()


# action du grapin sur la physique 
func hook_physics() -> void:
	if (hook != null):
		if (hook.fixed) : 
			var hookVector : Vector2 = hook.get_vector()
			var effectivePullForce = HOOK_PULL_FORCE * hook.get_tension()
			
			vel += hookVector.normalized() * effectivePullForce 
			
			if (hook.pullable) :
				hook.fixedOn.compute_hook_pull(hookVector, effectivePullForce)


# quand on entre dans la range d'un objet interactif, cette methode est appele par ObjetInteractif
func interactive_object_area_entered(objet : ObjetInteractif):
	objetInteractifProche = objet
	isObjetInteractifProche = true


# quand on sort dans la range d'un objet interactif, cette methode est appele par ObjetInteractif
func interactive_object_area_exited(objet : ObjetInteractif):
	objetInteractifProche = null
	isObjetInteractifProche = false
	
