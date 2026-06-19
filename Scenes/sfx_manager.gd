extends Node

@onready var click_sound: AudioStreamPlayer = $ClickSound

func play_click() -> void:
	click_sound.pitch_scale = randf_range(0.95, 1.05)
	click_sound.play()
