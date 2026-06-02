extends Node

const SAVE_FOLDER: String = "user://saves/"
const default_dictionary: Dictionary = {
	"Day": "Mon.",
	"Month": "January",
	"Money": 0
}

signal day_ended

func save_game(slot: int, data: Dictionary) -> void:
	ensure_save_folder()
	var save_path: String = SAVE_FOLDER + "save_%d.json" % slot
	var save_file: FileAccess = FileAccess.open(save_path, FileAccess.WRITE)
	
	if save_file == null:
		push_error("Error al abrir el archivo")
		return
	
	var string_data: String = JSON.stringify(data)
	
	save_file.store_line(string_data)
	save_file.close()
	
	print("Juego guardado con datos: ", string_data)

func ensure_save_folder() -> void:
	if not DirAccess.dir_exists_absolute(SAVE_FOLDER):
		DirAccess.make_dir_absolute(SAVE_FOLDER)
