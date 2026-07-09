extends Control

@onready var master_slider: HSlider = $MarginContainer/Panel/MarginContainer/VBoxContainer2/HBoxContainer/RightScrollContainer/MarginContainer/RightColumn/Master/GridContainer/HBoxContainer/MasterSlider
@onready var music_slider: HSlider = $MarginContainer/Panel/MarginContainer/VBoxContainer2/HBoxContainer/RightScrollContainer/MarginContainer/RightColumn/Music/GridContainer/HBoxContainer/MusicSlider
@onready var sounds_slider: HSlider = $MarginContainer/Panel/MarginContainer/VBoxContainer2/HBoxContainer/RightScrollContainer/MarginContainer/RightColumn/Sounds/GridContainer/HBoxContainer/SoundsSlider
@onready var margin_container: MarginContainer = $MarginContainer
@onready var texture_rect: TextureRect = $TextureRect

var cursor_texture := preload("res://Sprites/kenney_cursor-pack/PNG/Outline/Default/pointer_c_shaded.png")

@onready var TitleMusic: AudioStreamPlayer = $"../AudioStreamPlayer"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_master_slider_value_changed(value: float) -> void:
	TitleMusic.volume_db = linear_to_db(value) # To-Do: implementar un control maestro de música bg


func _on_visibility_changed() -> void:
	var tween: Tween = texture_rect.animate_to_desired()
	await tween.finished
	margin_container.visible = true

func _on_return_button_pressed() -> void:
	SfxManager.play_click()
	margin_container.visible = false
	var tween: Tween = texture_rect.animate_to_initial()
	await tween.finished
	
	SaveManager.save_especific_data(
		GameData.game_slot,
		"settings",
		{
			"auto_run": GameData.auto_run,
			"show_interaction": GameData.show_interaction,
			"hide_interaction_moving": GameData.hide_interaction_moving,
			"pause_game_inactive": GameData.pause_game_inactive,
			"master": GameData.master,
			"music": GameData.music,
			"sounds": GameData.sounds,
			"window_mode": GameData.window_mode,
			"resolution": GameData.resolution,
			"vsync": GameData.vsync,
			"ui_scale": GameData.ui_scale,
			"hardware_cursor": GameData.hardware_cursor,
			"max_fps": GameData.max_fps
		}
	)
	
	self.visible = false

func _on_default_settings_button_pressed() -> void:
	GameData.set_default()

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

func _on_vsync_check_box_toggled(toggled_on: bool) -> void:
	GameData.vsync = toggled_on
	
	if toggled_on:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

func _on_min_max_button_pressed(value: int) -> void:
	GameData.max_fps = value
	
	Engine.max_fps = value

func _on_cursor_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Input.set_custom_mouse_cursor(cursor_texture)
	else:
		Input.set_custom_mouse_cursor(null)
