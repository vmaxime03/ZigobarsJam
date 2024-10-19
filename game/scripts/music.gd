extends AudioStreamPlayer2D

var timer_start : int
var timer_end : int
var timer_set : bool
var main_theme := "res://assets/audio/Musics/Main_theme.wav"
var o2 := "res://assets/audio/Musics/O2.wav"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer_start = 0
	timer_end = 0
	# timer_set = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !self.playing and timer_start >= timer_end:
		timer_start = Time.get_ticks_msec()
		timer_end = RandomNumberGenerator.new().randi_range(0, 120000)
		if RandomNumberGenerator.new().randi_range(0,1) == 0:
			self.stream = load(main_theme)
		else:
			self.stream = load(o2)
		self.play()
		pass
	pass
