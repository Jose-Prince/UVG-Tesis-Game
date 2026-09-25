extends Node

const SAVE_FOLDER: String = "user://saves/"
const DEFAULT_DATA: Dictionary = {
	"player": {
		"name": "Akice",
		"money": 0,
		"popularity": 0
	},
	"world": {
		"day_index": 0,
		"num_day": 0,
		"month": 0,
		"year": 0,
	},
	"coffee_shop": {
		"name": "Place",
	},
}
const DEFAULT_SETTINGS = {
	"auto_run": true,
	"hardware_cursor": false,
	"hide_interaction_moving": true,
	"master": 1.0,
	"max_fps": 60,
	"music": 1.0,
	"pause_game_inactive": false,
	"resolution": 0,
	"show_interaction": true,
	"sounds": 1.0,
	"window_mode": 0
}

const SETTINGS_FILE := SAVE_FOLDER + "settings.json"

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

func save_especific_data(slot: int, data_slot: String, specific_data: Dictionary):
	var data = load_game(slot)
	data[data_slot] = specific_data
	save_game(slot, data)

func load_game(slot: int):
	var save_path := SAVE_FOLDER + "save_%d.json" % slot
	
	if not FileAccess.file_exists(save_path):
		return DEFAULT_DATA.duplicate()
	
	var save_file := FileAccess.open(save_path, FileAccess.READ)
	
	if save_file == null:
		return DEFAULT_DATA.duplicate()
	
	var json_string := save_file.get_as_text()
	save_file.close()
	
	var data = JSON.parse_string(json_string)
	
	if data == null:
		return DEFAULT_DATA.duplicate()
	
	return data

func ensure_save_folder() -> void:
	if not DirAccess.dir_exists_absolute(SAVE_FOLDER):
		DirAccess.make_dir_absolute(SAVE_FOLDER)

func save_exists(slot: int) -> bool:
	var save_path := SAVE_FOLDER + "save_%d.json" % slot
	return FileAccess.file_exists(save_path)

func get_save_count() -> int:
	var count := 0
	
	var dir := DirAccess.open(SAVE_FOLDER)
	
	if dir == null:
		return 0
	
	dir.list_dir_begin()
	
	var file_name := dir.get_next()
	
	while file_name != "":
		if not dir.current_is_dir():
			if file_name.begins_with("save_") and file_name.ends_with(".json"):
				count += 1
		
		file_name = dir.get_next()
	
	dir.list_dir_end()
	
	return count

func delete_save(slot: int) -> void:
	var save_path := SAVE_FOLDER + "save_%d.json" % slot

	if FileAccess.file_exists(save_path):
		DirAccess.remove_absolute(save_path)

func directory_has_content(path: String) -> bool:
	var dir := DirAccess.open(path)

	if dir == null:
		return false

	dir.list_dir_begin()

	var file_name := dir.get_next()

	while file_name != "":
		if file_name != "." and file_name != "..":
			dir.list_dir_end()
			return true

		file_name = dir.get_next()

	dir.list_dir_end()
	return false

func save_settings(settings: Dictionary) -> void:
	ensure_save_folder()
	
	var file := FileAccess.open(SETTINGS_FILE, FileAccess.WRITE)
	
	if file == null:
		push_error("Impossible to save game settings")
		return
		
	file.store_string(JSON.stringify(settings))
	file.close()

func load_settings() -> Dictionary:
	ensure_save_folder()
	
	if not FileAccess.file_exists(SETTINGS_FILE):
		return DEFAULT_SETTINGS.duplicate(true)
		
	var file := FileAccess.open(SETTINGS_FILE, FileAccess.READ)
	
	if file == null:
		return DEFAULT_SETTINGS.duplicate(true)
	
	var data = JSON.parse_string(file.get_as_text())
	
	file.close()
	
	if data == null:
		return DEFAULT_SETTINGS.duplicate(true)
		
	return data

func get_next_slot() -> int:
	var highest := -1
		
	var dir := DirAccess.open(SAVE_FOLDER)
		
	if dir == null:
		return 0
			
	dir.list_dir_begin()
		
	var file := dir.get_next()
		
	while file != "":
		if !dir.current_is_dir():
			if file.begins_with("save_") and file.ends_with(".json"):
				var number := file.trim_prefix("save_").trim_suffix(".json").to_int()
				
				highest = maxi(highest, number)
			
		file = dir.get_next()
			
	dir.list_dir_end()
		
	return highest + 1
