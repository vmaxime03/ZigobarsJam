class_name Player
extends CharacterBody2D

@export_file("*.txt") var save_file 

# ajout export pour l'inscpecteur
@export_group("UPGRADES")
@export_subgroup("SKILLS")
@export var hook_enable : bool = true
@export var dash_enable : bool = true
@export var brake_enable : bool = true
@export var aspirateur_enable : bool = true


@export_subgroup("STATS")
@export var BASE_SPEED : Vector2  = Vector2(300, 300)
@export var HOOK_PULL_FORCE : int = 10
@export var maxpower : int = 10
@export var minpower : int = 1
@export var maxo2 : float = 100
@export var maxcarb : int = 500
@export var dashBaseCD : int = 5
@export var dashCost : int = 30
@export var DASH_VELOCITY : Vector2 = Vector2(300, 300)
@export var argent : int = 0
@export var maxhp : int = 3
@export_subgroup("SKILL STATS")
@export_subgroup("GRAPPIN")
@export var hook_speed : Vector2 = Vector2(500,500)
@export var hook_maxdistance : int = 500
@export_subgroup("ASPIRATEUR")
@export var aspi_range : int = 256
@export var aspi_force : int = 50

@onready var o2 : float = maxo2
@onready var carb : int = maxcarb
@onready var hp : int = maxhp

@export_group("AFFICHAGE STATS")
@export var carbBar : TextureProgressBar = TextureProgressBar.new()
@export var o2Bar : TextureProgressBar = TextureProgressBar.new()
@export var interactButton : Button = Button.new()



@onready var power : int = minpower

@export_group("SCENE")
@export var body : Sprite2D
@export var arm : Sprite2D
@export var aspirateur : Aspirateur
@export var body_animation_tree : AnimationTree
@onready var body_state_machine : AnimationNodeStateMachinePlayback = body_animation_tree.get("parameters/playback")
@export var arm_animation_tree : AnimationTree
@onready var arm_state_machine : AnimationNodeStateMachinePlayback = arm_animation_tree.get("parameters/playback")

var isObjetInteractifProche : bool = false
var objetInteractifProche : ObjetInteractif = null

#scene de grappin pour instantation
var hookScene = preload("res://scenes/hook.tscn")
var hook : Hook


@onready var dashCD : int = 0


func save_to_file(): 
	var data := {
	"hook_enable" 		: var_to_str(hook_enable),
	"dash_enable" 		: var_to_str(dash_enable),
	"brake_enable" 		: var_to_str(dash_enable),
	"aspirateur_enable" : var_to_str(aspirateur_enable),
	"BASE_SPEED" 		: var_to_str(BASE_SPEED),
	"HOOK_PULL_FORCE" 	: var_to_str(HOOK_PULL_FORCE),
	"maxpower" 			: var_to_str(maxpower),
	"minpower" 			: var_to_str(minpower),
	"maxo2" 			: var_to_str(maxo2),
	"maxcarb" 			: var_to_str(maxcarb),
	"dashBaseCD" 		: var_to_str(dashBaseCD),
	"dashCost" 			: var_to_str(dashCost),
	"DASH_VELOCITY"		: var_to_str(DASH_VELOCITY),
	"argent" 			: var_to_str(argent),
	"maxhp" 			: var_to_str(maxhp),
	"hook_speed"		: var_to_str(hook_speed),
	"hook_maxdistance"  : var_to_str(hook_maxdistance),
	"aspi_range"		: var_to_str(aspi_range),
	"aspi_force"		: var_to_str(aspi_force)
	}
	
	if (not FileAccess.file_exists(save_file)):
		return
	var file_access := FileAccess.open(save_file, FileAccess.WRITE)
	file_access.store_line(var_to_str(data))
	file_access.close()


func init_from_file():
	if (not FileAccess.file_exists(save_file)):
		return
	var save_string := FileAccess.get_file_as_string(save_file)

	var data = str_to_var(save_string)

	hook_enable 		= str_to_var(data["hook_enable"])
	dash_enable 		= str_to_var(data["dash_enable"])
	brake_enable 		= str_to_var(data["dash_enable"])
	aspirateur_enable 	= str_to_var(data["aspirateur_enable"])
	BASE_SPEED	 		= str_to_var(data["BASE_SPEED"])
	HOOK_PULL_FORCE		= str_to_var(data["HOOK_PULL_FORCE"])
	maxpower 			= str_to_var(data["maxpower"])
	minpower 			= str_to_var(data["minpower"])
	maxo2 				= str_to_var(data["maxo2"])
	maxcarb 			= str_to_var(data["maxcarb"])
	dashBaseCD	 		= str_to_var(data["dashBaseCD"])
	dashCost 			= str_to_var(data["dashCost"])
	DASH_VELOCITY		= str_to_var(data["DASH_VELOCITY"])
	argent	 			= str_to_var(data["argent"])
	maxhp	 			= str_to_var(data["maxhp"])
	hook_speed			= str_to_var(data["hook_speed"])
	hook_maxdistance   	= str_to_var(data["hook_maxdistance"])
	aspi_range			= str_to_var(data["aspi_range"])
	aspi_force			= str_to_var(data["aspi_force"])


# TODO
func check_for_loose():
	pass

# update la barre de carburant
func _update_carb_bar() -> void :
	carbBar.value = carb

# bar d oxygene
func _update_o2_bar() -> void :
	o2Bar.value = o2 

# on ready
func _ready() -> void:
	init_from_file()

	carbBar.max_value = carb
	o2Bar.max_value = o2
	interactButton.hide()

	aspirateur.aspirange = aspi_range 
	aspirateur.aspiforce = aspi_force


func _exit_tree() -> void:
	save_to_file()


# vecteur recuperer a chaque execution 
var mousePos : Vector2
var vel : Vector2
var dir : Vector2

func _physics_process(delta: float) -> void:
	
	check_for_loose()


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
		body_state_machine.travel("move")
	else:
		if (power > minpower): 
			power-= 1

		# jouer l'animation
		body_state_machine.travel("idle")
	


	
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

	if (brake_enable):
		brake_action()

	if (aspirateur_enable):
		aspirateur_action()
	

	if (aspirateur.actif) : arm_state_machine.travel("aspirer")
	else : arm_state_machine.travel("idle")	

	# actualiser la barre de carburant
	_update_carb_bar()

	o2 -= delta
	_update_o2_bar()
	
	# on gere les rotation des sprite en fonction de la souris et de la velocité
	arm.rotation = atan2(mousePos.y - position.y, mousePos.x - position.x)
	body.rotation = vel.angle() 
	

	#deplacement 
	velocity = vel
	move_and_slide()
	

	
func aspirateur_action() -> void :
	aspirateur.actif = Input.is_action_pressed("r_click")
	
		

func brake_action():
	if Input.is_action_pressed("space"):
		vel *= 0.95

		if (vel.length()>10):
			carb -= 1

# action dash
func dash_action():
	if (Input.is_action_just_pressed("l_maj")) :
		if (dashCD <= 0 and carb >= dashCost) : 
			print("dash")
			dashCD = dashBaseCD
			carb -= dashCost
			vel += DASH_VELOCITY * dir.normalized()
			body_state_machine.travel("dash")
		else :
			pass
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
		hook.maxdistance = hook_maxdistance
		hook.speed = hook_speed

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
		
		
			var effectivePullForce = HOOK_PULL_FORCE * hook.get_tension() ** 2
			
			vel += hookVector.normalized() * effectivePullForce
			
			if (hook.pullable) :
				hook.fixedOn.compute_hook_pull(hookVector, effectivePullForce * vel.length())


# quand on entre dans la range d'un objet interactif, cette methode est appele par ObjetInteractif
func interactive_object_area_entered(objet : ObjetInteractif):
	objetInteractifProche = objet
	isObjetInteractifProche = true


# quand on sort dans la range d'un objet interactif, cette methode est appele par ObjetInteractif
func interactive_object_area_exited(objet : ObjetInteractif):
	objetInteractifProche = null
	isObjetInteractifProche = false
	
