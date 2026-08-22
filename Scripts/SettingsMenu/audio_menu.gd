extends Node

@onready var master_slider: HSlider = $Master/GridContainer/HBoxContainer/MasterSlider
@onready var music_slider: HSlider = $Music/GridContainer/HBoxContainer/MusicSlider
@onready var sounds_slider: HSlider = $Sounds/GridContainer/HBoxContainer/SoundsSlider

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	master_slider.grab_focus()
	_update_ui()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _update_ui() -> void:
	master_slider.value = GameData.master
	music_slider.value = GameData.music
	sounds_slider.value = GameData.sounds

func _on_master_slider_value_changed(value: float) -> void:
	GameData.master = value

func _on_music_slider_value_changed(value: float) -> void:
	GameData.music = value

func _on_sounds_slider_value_changed(value: float) -> void:
	GameData.sounds = value
