extends Node

const save_file_name: String = "res://saves/save.json"
const default_dictionary: Dictionary = {
	"Day": "Mon.",
	"Month": "January",
	"Money": 0
}

signal day_ended

func save_game(data: Dictionary) -> void:
	var save_file: FileAccess = FileAccess.open(save_file_name, FileAccess.WRITE)
	
	if save_file == null:
		push_error("Error al abrir el archivo")
		return
	
	var string_data: String = JSON.stringify(data)
	
	save_file.store_line(string_data)
	save_file.close()
	
	print("Juego guardado con datos: ", string_data)
