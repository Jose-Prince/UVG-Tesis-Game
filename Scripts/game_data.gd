extends Node

var cursor_texture := preload("res://Sprites/kenney_cursor-pack/PNG/Outline/Default/pointer_c_shaded.png")
var game_slot := 0

# Player variables
var player_name := ""
var money: float = 0.0
var popularity := 0

# Shop variables
var shop_name := ""
var menu_ids: Array = []
var menu: Array[ArticleData]

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

func _notification(what: int) -> void:
	if pause_game_inactive:
		match what:
			NOTIFICATION_APPLICATION_FOCUS_IN:
				get_tree().paused = false
			NOTIFICATION_APPLICATION_FOCUS_OUT:
				get_tree().paused = true

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

	apply_settings()

func apply_settings() -> void:
	match window_mode:
		0: # Fullscreen
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

		1: # Windowed
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)

		2: # Windowed Borderless
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

	apply_settings()
	
