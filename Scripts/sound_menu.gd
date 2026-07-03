extends Control

@onready var master_slider: HSlider = $Panel/VBoxContainer/MasterSlider
@onready var music_slider: HSlider = $Panel/VBoxContainer/MusicSlider
@onready var sounds_slider: HSlider = $Panel/VBoxContainer/SoundsSlider
@onready var margin_container: MarginContainer = $MarginContainer
@onready var texture_rect: TextureRect = $TextureRect

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
	self.visible = false
