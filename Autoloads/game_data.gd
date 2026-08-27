extends Node

var cursor_texture := preload("res://Placeholders/kenney_cursor-pack/PNG/Outline/Default/pointer_c_shaded.png")
var game_slot := 0

# Player variables
var player_name := ""
var money: float = 0.0
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
var day_index := 0
var num_day := 0
var year := 0

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
	KEYBOARD,
	MOUSE
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
			value.get("a", 1.0)
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

func load_to_data(data: Dictionary):
	player_name = data["player"]["name"]
	money = data["player"]["money"]
	popularity = data["player"]["popularity"]
	shop_name = data["coffee_shop"]["name"]
	menu_ids = data["coffee_shop"]["menu_ids"]
	day_index = data["world"]["day_index"]
	num_day = data["world"]["num_day"]
	month = data["world"]["month"]
	year = data["world"]["year"]

	if data["player"].has("appearance"):
		var app = data["player"]["appearance"]
		player_skin_color = _load_color(app.get("skin_color"), Color(1.0, 0.85, 0.70))
		player_hair_color = _load_color(app.get("hair_color"), Color(0.15, 0.10, 0.05))
		player_hair_style = int(app.get("hair_style", 0))
		player_shirt_style = int(app.get("shirt_style", 0))
		player_pants_style = int(app.get("pants_style", 0))
		player_shirt_color = _load_color(app.get("shirt_color"), Color(0.20, 0.40, 0.70))
		player_pants_color = _load_color(app.get("pants_color"), Color(0.30, 0.30, 0.30))
	else:
		player_skin_color = Color(1.0, 0.85, 0.70)
		player_hair_color = Color(0.15, 0.10, 0.05)
		player_hair_style = 0
		player_shirt_style = 0
		player_shirt_color = Color(0.20, 0.40, 0.70)
		player_pants_style = 0
		player_pants_color = Color(0.30, 0.30, 0.30)

func load_settings(data: Dictionary) -> void:
	auto_run = data["auto_run"]
	show_interaction = data["show_interaction"]
	hide_interaction_moving = data["hide_interaction_moving"]
	pause_game_inactive = data["pause_game_inactive"]
	master = data["master"]
	music = data["music"]
	sounds = data["sounds"]
	window_mode = data["window_mode"]
	resolution = data["resolution"]
	max_fps = data["max_fps"]
	hardware_cursor = data["hardware_cursor"]
	
	if data.has("inputs"):
		load_input_settings(data["inputs"])
	apply_settings()

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
	
	input_overrides.clear()

	# Restaurar los inputs originales del proyecto.
	for action in default_input_events:
		if action.begins_with("ui_") or action.begins_with("dialogic_"):
			continue
	
	apply_settings()
