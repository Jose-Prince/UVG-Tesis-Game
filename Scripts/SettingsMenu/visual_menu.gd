extends Node

signal settings_changed

const CURSOR_TEXTURE := preload("res://Placeholders/kenney_cursor-pack/PNG/Outline/Default/pointer_c_shaded.png")

@onready var window_option_button: OptionButton = $WindowMode/GridContainer/HBoxContainer/WindowOptionButton
@onready var resolution_option_button: OptionButton = $Resolution/GridContainer/HBoxContainer/ResolutionOptionButton
@onready var cursor_check_box: CheckBox = $HardwareCursor/GridContainer/HBoxContainer/CursorCheckBox
@onready var fps_min_max_button: MinMaxButton = $MaxFPS/GridContainer/HBoxContainer/FpsMinMaxButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	window_option_button.grab_focus()
	_update_ui()

func _update_ui() -> void:
	window_option_button.select(GameData.window_mode)
	resolution_option_button.select(GameData.resolution)
	cursor_check_box.button_pressed = GameData.hardware_cursor
	fps_min_max_button._set_numeric_value(GameData.max_fps)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_window_option_button_item_selected(index: int) -> void:
	GameData.window_mode = index
	
	match index:
		0: #Fullscreen
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		1: #Windowed
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		2: #Windowed Borderless
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	settings_changed.emit()

func _on_resolution_option_button_item_selected(index: int) -> void:
	GameData.resolution = index

	var resolution: Vector2i

	match index:
		0:
			resolution = Vector2i(1920, 1080)
		1:
			resolution = Vector2i(1680, 1050)
		2:
			resolution = Vector2i(1280, 1024)
		3:
			resolution = Vector2i(1600, 900)
		4:
			resolution = Vector2i(1366, 768)
		5:
			resolution = Vector2i(1280, 720)
	
	DisplayServer.window_set_size(resolution)
	var screen = DisplayServer.screen_get_usable_rect()
	var position = (screen.size - resolution) / 2
	DisplayServer.window_set_position(Vector2i(position))
	settings_changed.emit()

func _on_cursor_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Input.set_custom_mouse_cursor(CURSOR_TEXTURE)
	else:
		Input.set_custom_mouse_cursor(null)
	settings_changed.emit()

func _on_fps_min_max_button_pressed(value: int) -> void:
	GameData.max_fps
	Engine.max_fps = value
	settings_changed.emit()
