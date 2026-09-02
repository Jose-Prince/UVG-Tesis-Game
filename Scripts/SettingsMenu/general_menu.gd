extends VBoxContainer

signal settings_changed

@onready var ar_check_box: CheckBox = $AutoRun/GridContainer/HBoxContainer/ARCheckBox
@onready var location_check_box: CheckBox = $ShowInteractionLocation/GridContainer/HBoxContainer/LocationCheckBox
@onready var hide_check_box: CheckBox = $HideInteractionWhenMoving/GridContainer/HBoxContainer/HideCheckBox
@onready var pause_check_box: CheckBox = $PauseWhenGameInactive/GridContainer/HBoxContainer/PauseCheckBox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_ui()
	ar_check_box.grab_focus()

func _update_ui() -> void:
	ar_check_box.button_pressed = GameData.auto_run
	location_check_box.button_pressed = GameData.show_interaction
	hide_check_box.button_pressed = GameData.hide_interaction_moving
	pause_check_box.button_pressed = GameData.pause_game_inactive

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_ar_check_box_toggled(toggled_on: bool) -> void:
	GameData.auto_run = toggled_on
	settings_changed.emit()

func _on_location_check_box_toggled(toggled_on: bool) -> void:
	GameData.show_interaction = toggled_on
	settings_changed.emit()

func _on_hide_check_box_toggled(toggled_on: bool) -> void:
	GameData.hide_interaction_moving = toggled_on
	settings_changed.emit()

func _on_pause_check_box_toggled(toggled_on: bool) -> void:
	GameData.pause_game_inactive = toggled_on
	settings_changed.emit()
