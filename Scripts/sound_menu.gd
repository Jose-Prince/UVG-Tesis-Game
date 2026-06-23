extends Control

@onready var master_slider: HSlider = $Panel/VBoxContainer/MasterSlider
@onready var music_slider: HSlider = $Panel/VBoxContainer/MusicSlider
@onready var sounds_slider: HSlider = $Panel/VBoxContainer/SoundsSlider

@onready var TitleMusic: AudioStreamPlayer = $"../AudioStreamPlayer"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_return_button_pressed() -> void:
	SfxManager.play_click()
	self.visible = false

func _on_master_slider_value_changed(value: float) -> void:
	TitleMusic.volume_db = linear_to_db(value) # To-Do: implementar un control maestro de música bg
