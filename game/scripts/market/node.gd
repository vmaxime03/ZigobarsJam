class_name Donnees
extends Node 
@export_file("*.txt") var save_file =  "user://save.txt"
var data : Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_from_file()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func init_from_file():
	if (not FileAccess.file_exists(save_file)):
		return
	var save_string := FileAccess.get_file_as_string(save_file)
	data = str_to_var(save_string)

func save_to_file(): 	
	if (not FileAccess.file_exists(save_file)):
		return
	var file_access := FileAccess.open(save_file, FileAccess.WRITE)
	file_access.store_line(var_to_str(data))
	file_access.close()
	
func _exit_tree() -> void:
	save_to_file()

func set_data(key : String, val):
	if (!data) : init_from_file()
	data[key] = var_to_str(val)
	
func get_data(key : String):
	if (!data) : init_from_file()
	return str_to_var(data[key])
