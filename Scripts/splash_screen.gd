extends Control

const intro: AudioStream = preload("res://Music/Dream_Cafe_Intro.wav")
const loop: AudioStream = preload("res://Music/Dream_Cafe.ogg")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var settings = SaveManager.load_settings()
	
	print(linear_to_db(GameData.master))
	
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(GameData.master))
	MusicManager.adjust_volume(linear_to_db(GameData.music))
	SfxManager.adjust_volume(linear_to_db(GameData.sounds))
	
	GameData.load_settings(settings)
	MusicManager.play_song(intro, loop)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_pressed():
		get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")

func _on_video_stream_player_finished() -> void:
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")
