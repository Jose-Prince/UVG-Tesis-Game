extends Node

signal day_ended
signal day_start

const SAVE_FOLDER: String = "user://saves/"

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
	"window_mode": 0,
	"inputs": {},
	"interaction_mode": 0
}

const SETTINGS_FILE := SAVE_FOLDER + "settings.json"

func save_game(slot: int) -> void:
	ensure_save_folder()
	var save_path: String = SAVE_FOLDER + "save_%d.json" % slot
	var save_file: FileAccess = FileAccess.open(save_path, FileAccess.WRITE)
	
	if save_file == null:
		push_error("Error al abrir el archivo")
		return
	
	var data: Dictionary = GameData.get_save_data()
	var json_string: String = JSON.stringify(data)
	
	save_file.store_line(json_string)
	save_file.close()

func load_game(slot: int) -> bool:
	var data := read_save_data(slot)
	
	if data.is_empty():
		return false
	
	GameData.load_game_data(data)
	
	return true

func save_exists(slot: int) -> bool:
	var save_path := SAVE_FOLDER + "save_%d.json" % slot
	return FileAccess.file_exists(save_path)

func get_save_count() -> int:
	return get_save_slots().size()

func get_save_slots() -> Array[int]:
	var slots: Array[int] = []
	
	var dir := DirAccess.open(SAVE_FOLDER)
	
	if dir == null:
		return slots
	
	dir.list_dir_begin()
	
	var file_name := dir.get_next()
	
	while file_name != "":
		if not dir.current_is_dir():
			if file_name.begins_with("save_") and file_name.ends_with(".json"):
				var slot := file_name.trim_prefix("save_").trim_suffix(".json").to_int()
				slots.append(slot)
				
		file_name = dir.get_next()
	
	dir.list_dir_end()
	
	slots.sort()
	
	return slots

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
	var slots := get_save_slots()
		
	var slot := 0
	
	while slot in slots:
		slot += 1
		
	return slot

func ensure_save_folder() -> void:
	if not DirAccess.dir_exists_absolute(SAVE_FOLDER):
		var error := DirAccess.make_dir_absolute(SAVE_FOLDER)
		
		if error != OK:
			push_error("Could not create save folder.")

func read_save_data(slot: int) -> Dictionary:
	var save_path := SAVE_FOLDER + "save_%d.json" % slot
	
	if not FileAccess.file_exists(save_path):
		push_warning("Save file does not exist: " + save_path)
		return {}
	
	var save_file := FileAccess.open(save_path, FileAccess.READ)
	
	if save_file == null:
		push_error("Could not open save file: " + save_path)
		return {}
	
	var json_string := save_file.get_as_text()
	save_file.close()
	
	var data = JSON.parse_string(json_string)
	
	if data == null or not data is Dictionary:
		push_error("Invalid save data in: " + save_path)
		return {}
	
	return data
