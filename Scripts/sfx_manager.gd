extends Node

@onready var sfx_player: AudioStreamPlayer = $SFXPlayer

const click_sound: AudioStream = preload("res://Assets/Audios/button1.ogg")
const bell_sound: AudioStream = preload("res://Assets/Audios/bell1.ogg")
const liquid_sound: AudioStream = preload("res://Assets/Audios/liquid.mp3")
const money_sound: AudioStream = preload("res://Assets/Audios/chiklin.mp3")
const pick_sound: AudioStream = preload("res://Assets/Audios/pick.mp3")

func play_click() -> void:
	sfx_player.pitch_scale = randf_range(0.95, 1.05)
	sfx_player.stream = click_sound
	sfx_player.play()

func play_bell() -> void:
	sfx_player.pitch_scale = randf_range(0.95, 1.05)
	sfx_player.stream = bell_sound
	sfx_player.play()

func play_liquid() -> void:
	sfx_player.pitch_scale = randf_range(0.95, 1.05)
	sfx_player.stream = liquid_sound
	sfx_player.play()

func play_money() -> void:
	sfx_player.pitch_scale = randf_range(0.95, 1.0)
	sfx_player.stream = money_sound
	sfx_player.play()

func play_pick() -> void:
	sfx_player.pitch_scale = randf_range(1.0, 2.0)
	sfx_player.stream = pick_sound
	sfx_player.play()

func adjust_volume(volume: float) -> void:
	sfx_player.volume_db = volume
