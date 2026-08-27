class_name InputRow
extends HBoxContainer

@onready var action_label: Label = $ActionLabel
@onready var key_label: Label = $KeyLabel
@onready var change_button: Button = $ChangeButton

var action: String = ""

func setup(input_action: String) -> void:
	action = input_action
	
	action_label.text = input_action.capitalize()
	update_key()
	
func update_key() -> void:
	var events := InputMap.action_get_events(action)
	
	if events.is_empty():
		key_label.text = "-"
	else:
		key_label.text = events[0].as_text()
