extends TileMapLayer
@export var player : Player
@export var concentrationDechet : int = 1
# Called when the node enters the scene tree for the first time.
@onready var r = preload("res://scenes/Ressource.tscn")
func _ready() -> void:
	generate_map(player.position)
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func generate_map(position):
	var player_pos = local_to_map(position)
	var longueur = 1200
	var hauteur = 650
	var pos_x = player_pos.x
	var pos_y = player_pos.y
	var x1 =-player.carb-longueur
	var y1 =-player.carb-hauteur
	while(x1<=player.carb+longueur):
		while(y1<=player.carb+hauteur):
			if(concentrationDechet*1> RandomNumberGenerator.new().randi_range(0,concentrationDechet*10)):
				var x= RandomNumberGenerator.new().randi_range(0,50)
				var y= RandomNumberGenerator.new().randi_range(0,50)
				if(x>pos_x+10||x<pos_x-10):
					if(y>pos_y+10||y<pos_y-10):
						var r = r.instantiate()
						r.position.x = x1+x;
						r.position.y = y1+y;
						add_child(r)
			y1 += 50
		y1 = -player.carb-hauteur
		x1 +=50
