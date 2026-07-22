extends Control

@onready var control_2: Control = $Panel/MarginContainer/HBoxContainer/RightPanel/Control/MarginContainer2/NinePatchRect/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer2/Control2
@onready var load_game: Button = $Panel/MarginContainer/HBoxContainer/RightPanel/Control/MarginContainer2/NinePatchRect/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer2/LoadGame
@onready var sound_menu: Control = $SoundMenu

# Elements to animate
@onready var game_title: ResponsiveLabel = $Panel/MarginContainer/HBoxContainer/LeftPanel/GameTitle       # Left
@onready var coffee_drawing: TextureRect = $Panel/MarginContainer/HBoxContainer/LeftPanel/CoffeeDrawing   # Down
@onready var nine_patch_rect: NinePatchRect = $Panel/MarginContainer/HBoxContainer/RightPanel/Control/MarginContainer2/NinePatchRect # Up

# Buttons
@onready var new_game: ResponsiveButton = $Panel/MarginContainer/HBoxContainer/RightPanel/Control/MarginContainer2/NinePatchRect/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer2/NewGame


# How far off-screen (in px) each element starts before sliding in
const SLIDE_DISTANCE := 80.0
const ANIM_DURATION := 0.6
const ANIM_DELAY_STEP := 0.12

func _ready() -> void:
	load_game.visible = SaveManager.directory_has_content("user://saves/")
	control_2.visible = SaveManager.directory_has_content("user://saves/")

	# Wait one frame so layout/anchors have resolved final positions
	await get_tree().process_frame
	_animate_intro()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_pressed() and !event.is_action_pressed("ui_accept"):
		new_game.grab_focus()

func _animate_intro() -> void:
	_slide_in(game_title, Vector2(-SLIDE_DISTANCE, 0), 0.0)
	_slide_in(coffee_drawing, Vector2(0, SLIDE_DISTANCE), ANIM_DELAY_STEP)
	_slide_in(nine_patch_rect, Vector2(0, -SLIDE_DISTANCE), ANIM_DELAY_STEP * 2)

func _slide_in(node: Control, start_offset: Vector2, delay: float) -> void:
	var target_pos := node.position
	node.position = target_pos + start_offset
	node.modulate.a = 0.0

	var tween := create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(node, "position", target_pos, ANIM_DURATION).set_delay(delay)
	tween.tween_property(node, "modulate:a", 1.0, ANIM_DURATION).set_delay(delay)

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
