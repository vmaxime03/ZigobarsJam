extends TileMapLayer
@export var player : Player
@export var concentrationDechet : int = 10
# Called when the node enters the scene tree for the first time.
@onready var r = preload("res://scenes/objet_interactif.tscn")
func _ready() -> void:
	
	add_child(r.instantiate())
	print(get_child_count())
	#generate_map(player.position)
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func generate_map(position):
	var player_pos = local_to_map(position)
	var longueur = 120
	var hauteur = 65
	var pos_x = player_pos.x
	var pos_y = player_pos.y
	for x in range(-player.carb-longueur,player.carb+longueur):
		for y in range(-player.carb-hauteur,player.carb+hauteur):
			if(x>pos_x+player.body.texture.get_width()*2||x<pos_x-player.body.texture.get_width()*2):
				if(y>pos_y+player.body.texture.get_height()*2||y<pos_y-player.body.texture.get_height()*2):
					var creer = concentrationDechet*0.9 <= RandomNumberGenerator.new().randi_range(0,concentrationDechet)
					if(creer):
						var r = Ressource.new()
						r.position.x = x;
						r.position.y = y;
						add_child(r)
						print(get_child_count())
