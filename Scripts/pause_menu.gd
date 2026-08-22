extends Control

@onready var notebook: TextureRect = $Notebook

# Buttons
@onready var continue_button: UIButton = $Buttons/ContinueButton
@onready var settings_button: UIButton = $Buttons/SettingsButton
@onready var return_button: UIButton = $Buttons/ReturnButton

@onready var settings_menu: Control = $SettingsMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Pause"):
		toggle_pause()

func _unhandled_input(event: InputEvent) -> void:
	if !visible or settings_menu.visible:
		return
	
	if event.is_action_pressed("ui_up") \
	or event.is_action_pressed("ui_down") \
	or event.is_action_pressed("ui_left") \
	or event.is_action_pressed("ui_right"):
	
		if get_viewport().gui_get_focus_owner() == null:
			continue_button.grab_focus()

func toggle_pause():
	if get_tree().paused and !settings_menu.visible:
		var focus := get_viewport().gui_get_focus_owner()
		if focus:
			focus.release_focus()
		
		get_tree().paused = false
		hide()
	else:
		get_tree().paused = true
		show()
		continue_button.grab_focus()

func _on_continue_button_pressed() -> void:
	get_tree().paused = false
	print("CONTINUE CLICKED")
	hide()

func _on_return_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")

func _on_settings_button_pressed() -> void:
	notebook.hide()
	settings_menu.show()

func _on_continue_button_mouse_entered() -> void:
	continue_button.grab_focus()

func _on_settings_button_mouse_entered() -> void:
	settings_button.grab_focus()

func _on_return_button_mouse_entered() -> void:
	return_button.grab_focus()
