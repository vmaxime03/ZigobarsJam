extends AudioStreamPlayer2D

var timer_start : int
var timer_end : int
var soundList : Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer_start = Time.get_ticks_msec()
	timer_end = timer_start + RandomNumberGenerator.new().randi_range(0, 60000)
	getFiles(soundList, DirAccess.open("res://assets/audio/Voix/radio"))


# Ajoute dans la liste tous les fichiers audio récursivement dans le répertoire donné
func getFiles(list : Array, dir : DirAccess) -> void:
	if dir != null:
		for element in dir.get_files():
			if element.contains(".wav") and !element.contains(".import"):
				list.push_back(dir.get_current_dir() + "/" + element)
		var directories := dir.get_directories()
		for d in directories:
			getFiles(list, DirAccess.open(dir.get_current_dir() + "/" + d))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer_start = Time.get_ticks_msec()
	if self.playing:
		timer_end = timer_start + RandomNumberGenerator.new().randi_range(0, 60000)
	if !self.playing and timer_start >= timer_end:
		print("ok")
		self.stream = load(soundList[RandomNumberGenerator.new().randi_range(0, soundList.size()-1)])
		self.play()
