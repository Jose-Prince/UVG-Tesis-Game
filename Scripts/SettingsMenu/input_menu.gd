extends Control

signal settings_changed

const INPUT_ROW_SCENE = preload("res://Prefabs/input_row.tscn")

var waiting_row
var waiting_action: String = ""

@onready var input_container: VBoxContainer = $VBoxContainer/ScrollContainer/InputContainer
@onready var option_button: OptionButton = $VBoxContainer/VBoxContainer/HBoxContainer/OptionButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for action in InputMap.get_actions():
		if action.begins_with("ui_") or action.begins_with("dialogic_") or action.begins_with("pause"):
			continue
		
		if action.begins_with("key_") and GameData.interaction_mode == GameData.InteractionMode.MOUSE:
			continue
		if action.begins_with("mouse_") and GameData.interaction_mode == GameData.InteractionMode.KEYBOARD:
			continue
		
		var input_row = INPUT_ROW_SCENE.instantiate()
		
		input_container.add_child(input_row)
		input_row.setup(action)
		
		input_row.change_button.pressed.connect(
			_on_change_button.bind(input_row)
		)

func _on_change_button(row) -> void:
	if waiting_row != null:
		waiting_row.change_button.text = "Change"
	
	waiting_action = row.action
	waiting_row = row
	
	row.change_button.text = "..."
	settings_changed.emit()

func _input(event: InputEvent) -> void:
	if waiting_action == "":
		return
		
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		InputMap.action_erase_events(waiting_action)
		InputMap.action_add_event(waiting_action, event)
		
		GameData.set_input_override(
			waiting_action,
			event
		)
		
		waiting_row.update_key()
		waiting_row.change_button.text = "Change"
		
		waiting_action = ""
		waiting_row = null
		settings_changed.emit()

func update_input_rows() -> void:
	for child in input_container.get_children():
		var row := child as InputRow
		
		if row:
			row.update_key()

func _on_option_button_item_selected(index: int) -> void:
	match index:
		0:
			GameData.interaction_mode = GameData.InteractionMode.MOUSE
		1:
			GameData.interaction_mode = GameData.InteractionMode.KEYBOARD
			
	settings_changed.emit()
