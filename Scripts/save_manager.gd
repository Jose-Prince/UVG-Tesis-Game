extends Node

const SAVE_FOLDER: String = "res://saves/"
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

func load_game(slot: int):
	var save_path := SAVE_FOLDER + "save_%d.json" % slot
	
	if not FileAccess.file_exists(save_path):
		return default_dictionary.duplicate()
	
	var save_file := FileAccess.open(save_path, FileAccess.READ)
	
	if save_file == null:
		return default_dictionary.duplicate()
	
	var json_string := save_file.get_as_text()
	save_file.close()
	
	var data = JSON.parse_string(json_string)
	
	if data == null:
		return default_dictionary.duplicate()
	
	return data

func ensure_save_folder() -> void:
	if not DirAccess.dir_exists_absolute(SAVE_FOLDER):
		DirAccess.make_dir_absolute(SAVE_FOLDER)

func save_exists(slot: int) -> bool:
	var save_path := SAVE_FOLDER + "save_%d.json" % slot
	return FileAccess.file_exists(save_path)
