extends Control

@onready var resume_button: Button = $Panel/MarginContainer/VBoxContainer/ResumeButton
@onready var quit_button: Button = $Panel/MarginContainer/VBoxContainer/QuitButton

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	resume_button.pressed.connect(_on_resume_pressed)
	quit_button.pressed.connect(_on_quit_pressed)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		toggle_pause()


func toggle_pause() -> void:
	var paused := not get_tree().paused
	
	get_tree().paused = paused
	visible = paused


func _on_resume_pressed() -> void:
	get_tree().paused = false
	visible = false


func _on_settings_pressed() -> void:
	print("Settings pressed")


func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
