extends AudioStreamPlayer2D

var timer_start : int
var timer_end : int
var main_theme := "res://assets/audio/Musics/Main_theme.wav"
var o2 := "res://assets/audio/Musics/O2.wav"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer_start = 0
	timer_end = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer_start = Time.get_ticks_msec()
	if self.playing:
		timer_end = timer_start + RandomNumberGenerator.new().randi_range(0, 120000)
	if !self.playing and timer_start >= timer_end:
		if RandomNumberGenerator.new().randi_range(0,1) == 0:
			self.stream = load(main_theme)
		else:
			self.stream = load(o2)
		self.play()
		pass
	pass
