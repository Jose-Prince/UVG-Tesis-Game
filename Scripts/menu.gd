extends Control

@onready var control_2: Control = $Panel/MarginContainer/HBoxContainer/RightPanel/Control/MarginContainer2/NinePatchRect/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer2/Control2
@onready var load_game: Button = $Panel/MarginContainer/HBoxContainer/RightPanel/Control/MarginContainer2/NinePatchRect/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer2/LoadGame
@onready var sound_menu: Control = $SoundMenu

func _ready() -> void:
	load_game.visible = SaveManager.directory_has_content("user://saves/")
	control_2.visible = SaveManager.directory_has_content("user://saves/")

func _on_new_game_pressed() -> void:
	SfxManager.play_click()
	GameData.game_slot = SaveManager.get_save_count()
	get_tree().change_scene_to_file("res://Scenes/character_editor.tscn")
	
func _on_settings_pressed() -> void:
	SfxManager.play_click()
	sound_menu.visible = true
	
func _on_quit_pressed() -> void:
	SfxManager.play_click()
	get_tree().quit()

func _on_load_game_pressed() -> void:
	SfxManager.play_click()
	get_tree().change_scene_to_file("res://Scenes/files_screen.tscn")
