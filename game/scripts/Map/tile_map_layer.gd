extends TileMapLayer


@export var player : Player
@export var market : Node2D


@onready var r = preload("res://scenes/ressource_fix.tscn")
@onready var rr = preload("res://scenes/ressource_rare_fix.tscn")

@export var tileSize = 100
@export var longueur = 2000
@export var hauteur = 2000


func _ready() -> void:
	generate_map()


func generate_map():
	var x1 = -longueur
	var y1 = -hauteur
	while(x1<=longueur):
		while(y1<=hauteur):
			if (RandomNumberGenerator.new().randi_range(0, 5)==0):
				var x= RandomNumberGenerator.new().randi_range(x1,x1+tileSize)
				var y= RandomNumberGenerator.new().randi_range(y1, y1+tileSize)
				if((x>player.position.x+256 || x<player.position.x-256)&&
				(y>player.position.y+256 || y<player.position.y-256)&&
				(x>market.position.x+256 || x<market.position.x-256)&&
				(y>market.position.y+256 || y<market.position.y-256)
				):
					print("obfzibfhezfofkihebz")
					var rare = randf_range(0,1)
					var node : Node2D
					if(rare>0.95):
						print("rare")
						node = rr.instantiate()
					else:
						print("normal")
						node = r.instantiate()
					print(node.name)
					add_sibling(node)
					node.position.x = x1+x;
					node.position.y = y1+y;
			y1 += tileSize
		y1 = -hauteur
		x1 +=tileSize
