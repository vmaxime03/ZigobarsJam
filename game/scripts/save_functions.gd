@export_file("*.txt") var save_file 
func save_to_file(): 
	var data := {
	 	"hook_enable" 		: var_to_str(hook_enable),
	 	"dash_enable" 		: var_to_str(dash_enable),
	 	"brake_enable" 		: var_to_str(dash_enable),
	 	"aspirateur_enable" : var_to_str(aspirateur_enable),
	 	"BASE_SPEED" 		: var_to_str(BASE_SPEED),
	 	"HOOK_PULL_FORCE" 	: var_to_str(HOOK_PULL_FORCE),
	 	"maxpower" 			: var_to_str(maxpower),
	 	"minpower" 			: var_to_str(minpower),
	 	"maxo2" 			: var_to_str(maxo2),
	 	"maxcarb" 			: var_to_str(maxcarb),
	 	"dashBaseCD" 		: var_to_str(dashBaseCD),
	 	"dashCost" 			: var_to_str(dashCost),
	 	"DASH_VELOCITY"		: var_to_str(DASH_VELOCITY),
	 	"argent" 			: var_to_str(argent),
	 	"maxhp" 			: var_to_str(maxhp),
	 	"hook_speed"		: var_to_str(hook_speed),
	 	"hook_maxdistance"  : var_to_str(hook_maxdistance),
	 	"aspi_range"		: var_to_str(aspi_range),
	 	"aspi_force"		: var_to_str(aspi_force)
		}
	if (not FileAccess.file_exists(save_file)):
		return
	var file_access := FileAccess.open(save_file, FileAccess.WRITE)
	file_access.store_line(var_to_str(data))
	file_access.close()
