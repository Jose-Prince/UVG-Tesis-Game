extends Node

signal money_changed(new_amount: float)

var cursor_texture := preload("res://Placeholders/kenney_cursor-pack/PNG/Outline/Default/pointer_c_shaded.png")
var game_slot := 0

var process_time := true
var furniture_edit_mode := false

# Player variables
var player_name := ""
var money: float = 0.0:
	set(value):
		money = value
		money_changed.emit(money)
var popularity := 0

# Player appearance
var player_skin_color: Color = Color(1.0, 0.85, 0.70)
var player_hair_color: Color = Color(0.15, 0.10, 0.05)
var player_hair_style: int = 0
var player_shirt_style: int = 0
var player_shirt_color: Color = Color(0.20, 0.40, 0.70)
var player_pants_style: int = 0
var player_pants_color: Color = Color(0.30, 0.30, 0.30)

# Shop variables
var shop_name := ""
var menu_ids: Array = []
var menu: Array[ArticleData]
var open_hour := 7
var closed_hour := 17

# World variables
var month := 0
var day_index := 6
var num_day := 28
var year := 1

# Settings variables
var auto_run := false
var show_interaction := false
var hide_interaction_moving := false
var pause_game_inactive := false
var master := 1.0
var music := 1.0
var sounds := 1.0
var window_mode := 0
var resolution := 0
var hardware_cursor := true
var max_fps := 60

var default_input_events: Dictionary = {}
var input_overrides: Dictionary = {}

# Interaction systems
enum InteractionMode {
	MOUSE,
	KEYBOARD
}

var interaction_mode := InteractionMode.MOUSE

func is_shop_open(hour: int) -> bool:
	return hour >= open_hour and hour < closed_hour

func _notification(what: int) -> void:
	if pause_game_inactive:
		match what:
			NOTIFICATION_APPLICATION_FOCUS_IN:
				get_tree().paused = false
			NOTIFICATION_APPLICATION_FOCUS_OUT:
				get_tree().paused = true

func get_save_data() -> Dictionary:
	return {
		"player": {
			"name": player_name,
			"money": money,
			"appearance": {
				"skin_color": _color_to_data(player_skin_color),
				"hair_color": _color_to_data(player_hair_color),
				"hair_style": player_hair_style,
				"shirt_style": player_shirt_style,
				"shirt_color": _color_to_data(player_shirt_color),
				"pants_style": player_pants_style,
				"pants_color": _color_to_data(player_pants_color),
			}
		},
		"coffee_shop": {
			"name": shop_name,
			"menu_ids": menu_ids,
			"popularity": popularity,
			"furniture": {
				"inventory": FurnitureDatabase.furniture_inventory.duplicate(true),
				"placed": FurnitureDatabase.placed_furniture.duplicate(true)
			}
		},
		"world": {
			"day_index": day_index,
			"num_day": num_day,
			"month": month,
			"year": year
		}
	}

func load_game_data(data: Dictionary) -> void:
	var player_data: Dictionary = data.get("player", {})
	
	player_name = player_data.get("name", "")
	money = float(player_data.get("money", 0.0))
	
	var appearance: Dictionary = player_data.get("appearance", {})
	
	player_skin_color = _load_color(
		appearance.get("skin_color"),
		Color(1.0, 0.85, 0.70)
	)
	
	player_hair_color = _load_color(
		appearance.get("hair_color"),
		Color(1.0, 0.85, 0.70)
	)
	
	player_hair_color = _load_color(
		appearance.get("hair_color"),
		Color(0.15, 0.10, 0.05)
	)
	
	player_hair_style = int(appearance.get("hair_style", 0))
	player_shirt_style = int(appearance.get("shirt_style", 0))
	player_shirt_color = _load_color(
		appearance.get("shirt_color"),
		Color(0.20, 0.40, 0.70)
	)
	
	player_pants_style = int(appearance.get("pants_style", 0))
	player_pants_color = _load_color(
		appearance.get("pants_color"),
		Color(0.30, 0.30, 0.30)
	)
	
	var coffee_shop_data: Dictionary = data.get(
		"coffee_shop",
		{}
	)
	
	shop_name = coffee_shop_data.get("name", "")
	menu_ids = coffee_shop_data.get("menu_ids", [])
	popularity = int(coffee_shop_data.get("popularity", 0))
	
	var furniture_data: Dictionary = coffee_shop_data.get("furniture", {})
	
	var saved_inventory: Dictionary = furniture_data.get("inventory", {})
	
	FurnitureDatabase.furniture_inventory.clear()
	for furniture in FurnitureDatabase.furniture_catalog:
		if furniture == null:
			continue
		
		FurnitureDatabase.furniture_inventory[furniture.id] = 0
	
	for furniture_id in saved_inventory:
		FurnitureDatabase.furniture_inventory[furniture_id] = int(saved_inventory[furniture_id])
	
	FurnitureDatabase.placed_furniture.clear()
	
	var saved_placed_furniture: Array = furniture_data.get("placed", [])
	
	for saved_furniture in saved_placed_furniture:
		if not saved_furniture is Dictionary:
			continue
		
		var furniture_id: String = str(saved_furniture.get("id", ""))
		
		if furniture_id.is_empty():
			continue
		
		FurnitureDatabase.placed_furniture.append({
			"id": furniture_id,
			"x": float(saved_furniture.get("x", 0.0)),
			"y": float(saved_furniture.get("y", 0.0))
		})
	
	var world_data: Dictionary = data.get("world", {})
	
	day_index = int(world_data.get("day_index", 0))
	num_day = int(world_data.get("num_day", 0))
	month = int(world_data.get("month", 0))
	year = int(world_data.get("year", 0))

func _color_to_data(color: Color) -> Dictionary:
	return {
		"r": color.r,
		"g": color.g,
		"b": color.b,
		"a": color.a
	}

func _load_color(value, default_color: Color) -> Color:
	if value == null:
		return default_color
	if value is Color:
		return value
	if value is Dictionary:
		return Color(
			value.get("r", default_color.r),
			value.get("g", default_color.g),
			value.get("b", default_color.b),
			value.get("a", default_color.a)
		)
	if value is String:
		# parse "(r, g, b, a)" format
		var cleaned = value.replace("(", "").replace(")", "").strip_edges()
		var parts = cleaned.split(",")
		if parts.size() >= 3:
			return Color(
				float(parts[0].strip_edges()),
				float(parts[1].strip_edges()),
				float(parts[2].strip_edges()),
				float(parts[3].strip_edges()) if parts.size() >= 4 else 1.0
			)
	return default_color

func load_settings(data: Dictionary) -> void:
	auto_run = data.get("auto_run", true)
	show_interaction = data.get("show_interaction", true)
	hide_interaction_moving = data.get("hide_interaction_moving", true)
	pause_game_inactive = data.get("pause_game_inactive", false)
	master = data.get("master", 1.0)
	music = data.get("music", 1.0)
	sounds = data.get("sounds", 1.0)
	window_mode = int(data.get("window_mode", 0))
	resolution = int(data.get("resolution", 0))
	max_fps = int(data.get("max_fps", 60))
	hardware_cursor = data.get("hardware_cursor", false)
	interaction_mode = int(data.get("interaction_mode", InteractionMode.MOUSE))
	
	if data.has("inputs"):
		load_input_settings(data["inputs"])
	apply_settings()
	apply_audio_settings()

func apply_settings() -> void:
	match window_mode:
		0:
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)

	var resolutions: Vector2i

	match resolution:
		0:
			resolutions = Vector2i(1920, 1080)
		1:
			resolutions = Vector2i(1680, 1050)
		2:
			resolutions = Vector2i(1280, 1024)
		3:
			resolutions = Vector2i(1600, 900)
		4:
			resolutions = Vector2i(1366, 768)
		5:
			resolutions = Vector2i(1280, 720)
		_:
			resolutions = Vector2i(1920, 1080)

	DisplayServer.window_set_size(resolutions)
	var screen = DisplayServer.screen_get_usable_rect()
	var position = (screen.size - resolutions) / 2
	DisplayServer.window_set_position(Vector2i(position))

	if hardware_cursor:
		Input.set_custom_mouse_cursor(cursor_texture)
	else:
		Input.set_custom_mouse_cursor(null)
	Engine.max_fps = max_fps

func cache_default_inputs() -> void:
	default_input_events.clear()
	
	for action in InputMap.get_actions():
		if action.begins_with("ui_") or action.begins_with("dialogic_"):
			continue
		
		var events := InputMap.action_get_events(action)
		
		default_input_events[action] = events.duplicate()

func load_input_settings(data: Dictionary) -> void:
	for action in data:
		if not InputMap.has_action(action):
			continue
		
		var input_data: Dictionary = data[action]
		
		if input_data.get("type") == "key":
			var event := InputEventKey.new()
			event.keycode = int(input_data.get("keycode", 0))
			
			InputMap.action_erase_events(action)
			InputMap.action_add_event(action, event)

func set_input_override(action: String, event: InputEvent) -> void:
	if event is InputEventKey:
		input_overrides[action] = {
			"type": "key",
			"keycode": event.keycode
		}

func reset_inputs_to_default() -> void:
	input_overrides.clear()
	
	for action in default_input_events:
		if not InputMap.has_action(action):
			continue
		
		InputMap.action_erase_events(action)
		
		for event in default_input_events[action]:
			InputMap.action_add_event(
				action,
				event.duplicate(true)
			)

func set_default():
	auto_run = true
	show_interaction = true
	hide_interaction_moving = true
	pause_game_inactive = false
	master = 1.0
	music = 1.0
	sounds = 1.0
	window_mode = 0
	resolution = 0
	max_fps = 60
	hardware_cursor = false
	interaction_mode = InteractionMode.MOUSE
	
	reset_inputs_to_default()
	
	apply_settings()

func apply_audio_settings() -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(master))
	MusicManager.adjust_volume(linear_to_db(music))
	SfxManager.adjust_volume(linear_to_db(sounds))
