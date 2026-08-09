extends Control

@onready var input_container: MarginContainer = $MarginContainer/Panel/MarginContainer/VBoxContainer2/HSeparator2/ScrollContainer/MarginContainer

@onready var ar_check_box: CheckBox = $MarginContainer/Panel/MarginContainer/VBoxContainer2/HBoxContainer/LeftScrollContainer/MarginContainer/LeftColumn/AutoRun/GridContainer/HBoxContainer/ARCheckBox
@onready var location_check_box: CheckBox = $MarginContainer/Panel/MarginContainer/VBoxContainer2/HBoxContainer/LeftScrollContainer/MarginContainer/LeftColumn/ShowInteractionLocation/GridContainer/HBoxContainer/LocationCheckBox
@onready var hide_check_box: CheckBox = $MarginContainer/Panel/MarginContainer/VBoxContainer2/HBoxContainer/LeftScrollContainer/MarginContainer/LeftColumn/HideInteractionWhenMoving/GridContainer/HBoxContainer/HideCheckBox
@onready var pause_check_box: CheckBox = $MarginContainer/Panel/MarginContainer/VBoxContainer2/HBoxContainer/LeftScrollContainer/MarginContainer/LeftColumn/PauseWhenGameInactive/GridContainer/HBoxContainer/PauseCheckBox

@onready var window_option_button: OptionButton = $MarginContainer/Panel/MarginContainer/VBoxContainer2/HBoxContainer/RightScrollContainer/MarginContainer/RightColumn/WindowMode/GridContainer/HBoxContainer/WindowOptionButton
@onready var resolution_option_button: OptionButton = $MarginContainer/Panel/MarginContainer/VBoxContainer2/HBoxContainer/RightScrollContainer/MarginContainer/RightColumn/Resolution/GridContainer/HBoxContainer/ResolutionOptionButton
@onready var cursor_check_box: CheckBox = $MarginContainer/Panel/MarginContainer/VBoxContainer2/HBoxContainer/RightScrollContainer/MarginContainer/RightColumn/HardwareCursor/GridContainer/HBoxContainer/CursorCheckBox
@onready var fps_min_max_button: MinMaxButton = $MarginContainer/Panel/MarginContainer/VBoxContainer2/HBoxContainer/RightScrollContainer/MarginContainer/RightColumn/MaxFPS/GridContainer/HBoxContainer/FpsMinMaxButton

@onready var master_slider: HSlider = $MarginContainer/Panel/MarginContainer/VBoxContainer2/HBoxContainer/RightScrollContainer/MarginContainer/RightColumn/Master/GridContainer/HBoxContainer/MasterSlider
@onready var music_slider: HSlider = $MarginContainer/Panel/MarginContainer/VBoxContainer2/HBoxContainer/RightScrollContainer/MarginContainer/RightColumn/Music/GridContainer/HBoxContainer/MusicSlider
@onready var sounds_slider: HSlider = $MarginContainer/Panel/MarginContainer/VBoxContainer2/HBoxContainer/RightScrollContainer/MarginContainer/RightColumn/Sounds/GridContainer/HBoxContainer/SoundsSlider
@onready var margin_container: MarginContainer = $MarginContainer
@onready var texture_rect: TextureRect = $TextureRect

var INPUT_MENU_SCENE := preload("res://Scenes/input_menu.tscn")

@onready var input_dictionary: Dictionary = {}

var cursor_texture := preload("res://Sprites/kenney_cursor-pack/PNG/Outline/Default/pointer_c_shaded.png")
var title_music: AudioStreamPlayer 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	title_music = get_tree().current_scene.find_child("AudioStreamPlayer", true, false)
	var input_menu_instance = INPUT_MENU_SCENE.instantiate()
	input_container.add_child(input_menu_instance)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_ui() -> void:
	ar_check_box.button_pressed = GameData.auto_run
	location_check_box.button_pressed = GameData.show_interaction
	hide_check_box.button_pressed = GameData.hide_interaction_moving
	pause_check_box.button_pressed = GameData.pause_game_inactive
	
	master_slider.value = GameData.master
	music_slider.value = GameData.music
	sounds_slider.value = GameData.sounds
	
	window_option_button.select(GameData.window_mode)
	resolution_option_button.select(GameData.resolution)
	
	cursor_check_box.button_pressed = GameData.hardware_cursor
	
	fps_min_max_button._set_numeric_value(GameData.max_fps)

func _on_master_slider_value_changed(value: float) -> void:
	title_music.volume_db = linear_to_db(value) # To-Do: implementar un control maestro de música bg

func _on_visibility_changed() -> void:
	if visible:
		update_ui()
		
	var tween: Tween = texture_rect.animate_to_desired()
	await tween.finished
	margin_container.visible = true

func _on_return_button_pressed() -> void:
	var settings_dictionary: Dictionary = {
		"auto_run": GameData.auto_run,
		"hardware_cursor": GameData.hardware_cursor,
		"hide_interaction_moving": GameData.hide_interaction_moving,
		"master": GameData.master,
		"max_fps": GameData.max_fps,
		"music": GameData.music,
		"pause_game_inactive": GameData.pause_game_inactive,
		"resolution": GameData.resolution,
		"show_interaction": GameData.show_interaction,
		"sounds": GameData.sounds,
		"window_mode": GameData.window_mode
		}
	
	SaveManager.save_settings({
		
	})
	
	SfxManager.play_click()
	margin_container.visible = false
	var tween: Tween = texture_rect.animate_to_initial()
	await tween.finished
	
	self.visible = false

func _on_default_settings_button_pressed() -> void:
	GameData.set_default()
	update_ui()

func _on_ar_check_box_toggled(toggled_on: bool) -> void:
	GameData.auto_run = toggled_on

func _on_location_check_box_toggled(toggled_on: bool) -> void:
	GameData.show_interaction = toggled_on

func _on_hide_check_box_toggled(toggled_on: bool) -> void:
	GameData.hide_interaction_moving = toggled_on

func _on_pause_check_box_toggled(toggled_on: bool) -> void:
	GameData.pause_game_inactive = toggled_on

func _on_master_h_slider_value_changed(value: float) -> void:
	GameData.master = value

func _on_music_h_slider_value_changed(value: float) -> void:
	GameData.music = value

func _on_sounds_h_slider_value_changed(value: float) -> void:
	GameData.sounds = value

func _on_window_option_button_item_selected(index: int) -> void:
	GameData.window_mode = index

	match index:
		0: # Fullscreen
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

		1: # Windowed
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)

		2: # Windowed Borderless
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)

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

func _on_cursor_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Input.set_custom_mouse_cursor(cursor_texture)
	else:
		Input.set_custom_mouse_cursor(null)

func _on_fps_min_max_button_pressed(value: int) -> void:
	GameData.max_fps = value
	
	Engine.max_fps = value
