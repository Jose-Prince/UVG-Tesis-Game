extends Node

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
var vsync := false
var ui_scale := 1.0
var hardware_cursor := false
var max_fps := 60

# Default settings values
var _auto_run := false
var _show_interaction := false
var _hide_interaction_moving := false
var _pause_game_inactive := false
var _master := 1.0
var _music := 1.0
var _sounds := 1.0
var _window_mode := 0
var _resolution := 0
var _vsync := false
var _ui_scale := 1.0
var _hardware_cursor := false
var _max_fps := 60

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

func set_default() -> void:
	auto_run = _auto_run
	show_interaction = _show_interaction
	hide_interaction_moving = _hide_interaction_moving
	pause_game_inactive = _pause_game_inactive
	master = _master
	music = _music
	sounds = _sounds
	window_mode = _window_mode
	resolution = _resolution
	vsync = _vsync
	ui_scale = _ui_scale
	hardware_cursor = _hardware_cursor
	max_fps = _max_fps
