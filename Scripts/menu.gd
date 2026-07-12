extends Control

@onready var control_2: Control = $Panel/MarginContainer/HBoxContainer/RightPanel/Control/MarginContainer2/NinePatchRect/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer2/Control2
@onready var load_game: Button = $Panel/MarginContainer/HBoxContainer/RightPanel/Control/MarginContainer2/NinePatchRect/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer2/LoadGame
@onready var sound_menu: Control = $SoundMenu

# Elements to animate
# Left
@onready var game_title: ResponsiveLabel = $Panel/MarginContainer/HBoxContainer/LeftPanel/GameTitle
# Down
@onready var coffee_drawing: TextureRect = $Panel/MarginContainer/HBoxContainer/LeftPanel/CoffeeDrawing
# Up
@onready var nine_patch_rect: NinePatchRect = $Panel/MarginContainer/HBoxContainer/RightPanel/Control/MarginContainer2/NinePatchRect

func _ready() -> void:
	load_game.visible = SaveManager.directory_has_content("user://saves/")
	control_2.visible = SaveManager.directory_has_content("user://saves/")
	
	animate_intro()

func animate_intro():
	var title_pos = game_title.position
	var coffee_pos = coffee_drawing.position
	var panel_pos = nine_patch_rect.position

	# Posiciones iniciales
	game_title.position.x -= 400        # Desde la izquierda
	coffee_drawing.position.y += 300    # Desde abajo
	nine_patch_rect.position.y -= 300   # Desde arriba

	# Opcional: aparecen con fade
	game_title.modulate.a = 0
	coffee_drawing.modulate.a = 0
	nine_patch_rect.modulate.a = 0

	var tween = create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)

	# Título
	tween.tween_property(game_title, "position", title_pos, 0.5)
	tween.tween_property(game_title, "modulate:a", 1.0, 0.5)

	# Café
	tween.tween_property(coffee_drawing, "position", coffee_pos, 0.6)
	tween.tween_property(coffee_drawing, "modulate:a", 1.0, 0.6)

	# Panel derecho
	tween.tween_property(nine_patch_rect, "position", panel_pos, 0.5)
	tween.tween_property(nine_patch_rect, "modulate:a", 1.0, 0.5)

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
