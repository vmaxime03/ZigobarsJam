class_name Ressource
extends ObjetInteractif

const asteroid = 0;
const débris_vaisseau =1
const artefact =2
var texture : Sprite2D 
@export var maxvalue =900 
@export var minvalue = 300 
@export var maxsize =16
@export var minsize =12
@export var type = RandomNumberGenerator.new().randi_range(0,2)
var possede_boite_noire
@export var rare =false
@export var rare_coefficient = RandomNumberGenerator.new().randf_range(0,4)
@onready var size = RandomNumberGenerator.new().randf_range(minsize,maxsize)
@onready var value = RandomNumberGenerator.new().randf_range(minvalue,maxvalue)*size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(type == débris_vaisseau):
		possede_boite_noire = true
	else:
		possede_boite_noire = false
	print(_getValue())
	print(_getBoiteNoire())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _getValue()->int:
	if(rare):
		value *=rare_coefficient
	value += value*type
	return int(value)
func _getBoiteNoire()->String:
	var boite_noire =""
	if(possede_boite_noire):
		boite_noire = "test"
	return boite_noire
