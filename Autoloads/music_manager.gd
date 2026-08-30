extends Node

@onready var ambience_music_player: AudioStreamPlayer = $MusicPlayer

var current_loop: AudioStream
var loop_finished: bool = false

## Indica al reproductor de música que debe reproducir una pista seleccionada
func play_song(intro_file: AudioStream, loop_file: AudioStream) -> void:
	current_loop = loop_file
	
	if intro_file != null:
		loop_finished = false
		
		ambience_music_player.stream = intro_file
		ambience_music_player.play()
		
	else:
		ambience_music_player.stream = loop_file
		ambience_music_player.play()

func _on_music_player_finished() -> void:
	loop_finished = true
	
	ambience_music_player.stream = current_loop
	ambience_music_player.play()

func adjust_volume(volume: float):
	ambience_music_player.volume_db = volume
