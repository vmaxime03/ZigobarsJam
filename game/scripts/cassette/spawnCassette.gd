extends Node2D

var soundList : Array
var player


@export var audioPlayer : PackedScene
var audioPlayerList : Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	getFiles(soundList, DirAccess.open("res://assets/audio/Voix/cassettes"))

# Ajoute dans la liste tous les fichiers audio récursivement dans le répertoire donné
func getFiles(list : Array, dir : DirAccess) -> void:
	if dir != null:
		for element in dir.get_files():
			if element.contains(".wav") and !element.contains(".import"):
				list.push_back(dir.get_current_dir() + "/" + element)
		var directories := dir.get_directories()
		for d in directories:
			getFiles(list, DirAccess.open(dir.get_current_dir() + "/" + d))

# Instancie un objet AudioStreamPlayer2D qui joue la cassette et retourne le chemin du fichier audio
func getCassette() -> String:
	var rs = ""
	print(soundList.size())
	if soundList.size() > 0 :
		player = audioPlayer.instantiate()
		var rng = RandomNumberGenerator.new()
		var num = rng.randi_range(0, soundList.size()-1)
		rs = soundList.pop_at(num)
		$".".add_child(player)
		$"CassettePlayer".stream = load(rs)
		$"CassettePlayer".play()
	return rs

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# tester la méthode
	# if Input.is_action_pressed("z"):
	# 	print("ok")
	# 	getCassette()
	pass
