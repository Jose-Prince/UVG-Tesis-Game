extends Control

const GENERAL_SETTINGS_SCENE = preload("res://Scenes/MenuSettings/general_settings.tscn")
const AUDIO_SETTINGS_SCENE = preload("res://Scenes/MenuSettings/audio_settings.tscn")
const VISUAL_SETTINGS_SCENE = preload("res://Scenes/MenuSettings/visual_settings.tscn")
const INPUT_SETTINGS_SCENE = preload("res://Scenes/MenuSettings/input_settings.tscn")

var general_settings
var audio_settings
var visual_settings
var input_settings

@onready var notebook: TextureRect = $"../Notebook"
@onready var notebook_sprite: AnimatedTextureRect = $NotebookSprite
@onready var v_box_container: VBoxContainer = $MarginContainer/VBoxContainer

@onready var general_button: Button = $ButtonsContainer/GeneralButton
@onready var audio_button: Button = $ButtonsContainer/AudioButton
@onready var visual_button: Button = $ButtonsContainer/VisualButton
@onready var input_button: Button = $ButtonsContainer/InputButton

@onready var settings_container: MarginContainer = $MarginContainer/VBoxContainer/SettingsContainer
@onready var save_button: Button = $MarginContainer/VBoxContainer/ButtonsContainer/HBoxContainer/SaveButton

func _ready() -> void:
	general_button.grab_focus()
	
	general_settings = GENERAL_SETTINGS_SCENE.instantiate()
	settings_container.add_child(general_settings)
	general_settings.settings_changed.connect(_on_settings_changed)
	
	audio_settings = AUDIO_SETTINGS_SCENE.instantiate()
	settings_container.add_child(audio_settings)
	audio_settings.hide()
	
	visual_settings = VISUAL_SETTINGS_SCENE.instantiate()
	settings_container.add_child(visual_settings)
	visual_settings.hide()
	
	input_settings = INPUT_SETTINGS_SCENE.instantiate()
	settings_container.add_child(input_settings)
	input_settings.hide()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Pause") and self.visible:
		await notebook_sprite.play_animation_backwards()
		
		if notebook:
			notebook.show()
		self.hide()

func update_ui() -> void:
	general_settings._update_ui()
	audio_settings._update_ui()
	visual_settings._update_ui()
	#input_settings._upadte_ui()

func _on_settings_changed() -> void:
	save_button.disabled = false

func _on_visibility_changed() -> void:
	if self.visible and notebook_sprite:
		notebook_sprite.play_animation()


func _on_general_button_pressed() -> void:
	general_button.grab_focus()
	
	general_settings.show()
	audio_settings.hide()
	visual_settings.hide()
	input_settings.hide()

func _on_audio_button_pressed() -> void:
	audio_button.grab_focus()
	
	general_settings.hide()
	audio_settings.show()
	visual_settings.hide()
	input_settings.hide()

func _on_visual_button_pressed() -> void:
	visual_button.grab_focus()
	
	general_settings.hide()
	audio_settings.hide()
	visual_settings.show()
	input_settings.hide()

func _on_input_button_pressed() -> void:
	input_button.grab_focus()
	
	general_settings.hide()
	audio_settings.hide()
	visual_settings.hide()
	input_settings.show()

func _on_back_button_pressed() -> void:
	await notebook_sprite.play_animation_backwards()
	
	if notebook:
		notebook.show()
	self.hide()

func _on_default_button_pressed() -> void:
	GameData.set_default()
	update_ui()
	save_button.disabled = true

func _on_save_button_pressed() -> void:
	save_button.disabled = true
