class_name Player
extends CharacterBody2D

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

var hookScene = preload("res://scenes/hook.tscn")
var hook : Hook


@onready var dashCD : int = 0


func _update_carb_bar() -> void :
	carbBar.value = carb

func _ready() -> void:
	carbBar.max_value = carb
	
	interactButton.hide()


var mousePos : Vector2
var vel : Vector2
var dir : Vector2

func _physics_process(delta: float) -> void:
	mousePos = get_global_mouse_position()
	vel = velocity
	dir = Input.get_vector("q", "d", "z", "s")
	
	var p : float = 2 * (float(power) / maxpower )
	
	if (dir != Vector2.ZERO):
		vel += dir * BASE_SPEED * delta * p
		if (power < maxpower):
			power += 1
		carb -= 1
		state_machine.travel("move")
	else:
		if (power > minpower): 
			power-= 1
		state_machine.travel("idle")
	
	
	interact_action()
	
	if (hook_enable):
		hook_action()
		hook_physics()
	
	if (dash_enable):
		dash_action()
	
	_update_carb_bar()
	
	arm.rotation = atan2(mousePos.y - position.y, mousePos.x - position.x)
	body.rotation = vel.angle() 
	
	velocity = vel
	move_and_slide()
	

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


func hook_action() -> void:
	if (Input.is_action_just_pressed("l_click")):
		hook = hookScene.instantiate()
		hook.player = self
		get_tree().root.add_child(hook)
		get_tree().root.add_child(hook.rope)
		
	if (Input.is_action_just_released("l_click")):
		if (hook != null) : hook.delete()


func hook_physics() -> void:
	if (hook != null):
		if (hook.fixed) : 
			var hookVector : Vector2 = hook.get_vector()
			var effectivePullForce = HOOK_PULL_FORCE * hook.get_tension()
			vel += hookVector.normalized() * effectivePullForce 
			
			if (hook.pullable) :
				hook.fixedOn.compute_hook_pull(hookVector, effectivePullForce)


func interactive_object_area_entered(objet : ObjetInteractif):
	objetInteractifProche = objet
	isObjetInteractifProche = true


func interactive_object_area_exited(objet : ObjetInteractif):
	objetInteractifProche = null
	isObjetInteractifProche = false
	
