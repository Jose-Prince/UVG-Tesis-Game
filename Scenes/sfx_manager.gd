extends Node

@onready var click_sound: AudioStreamPlayer = $ClickSound
@onready var bell_sound: AudioStreamPlayer = $BellSound
@onready var liquid_sound: AudioStreamPlayer = $LiquidFillingSound
@onready var money_sound: AudioStreamPlayer = $MoneySound
@onready var pick_sound: AudioStreamPlayer = $PickSound

func play_click() -> void:
	click_sound.pitch_scale = randf_range(0.95, 1.05)
	click_sound.play()
	
func play_bell() -> void:
	bell_sound.pitch_scale = randf_range(0.95, 1.05)
	bell_sound.play()
	
func play_liquid() -> void:
	liquid_sound.pitch_scale = randf_range(0.95, 1.05)
	liquid_sound.play()
	
func play_money() -> void:
	money_sound.pitch_scale = randf_range(0.95, 1.05)
	money_sound.play()
	
func play_pick() -> void:
	pick_sound.pitch_scale = randf_range(1.0, 2.0)
	pick_sound.play()
