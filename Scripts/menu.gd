extends Control
	
func _on_new_game_pressed() -> void:
	SaveManager.load_game(1)
	get_tree().change_scene_to_file("res://Scenes/character_editor.tscn")
	
func _on_settings_pressed() -> void:
	pass # Replace with function body.
	
func _on_quit_pressed() -> void:
	get_tree().quit()
