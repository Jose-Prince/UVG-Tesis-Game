class_name InputRow
extends HBoxContainer

@onready var action_label: Label = $ActionLabel
@onready var key_label: Label = $KeyLabel
@onready var change_button: Button = $ChangeButton

var action: String = ""

func setup(input_action: String) -> void:	
	var label_name := input_action.trim_prefix("key_").trim_prefix("mouse_")
	action_label.text = label_name.capitalize()
	update_key()
	
func update_key() -> void:
	var events := InputMap.action_get_events(action)
	
	if events.is_empty():
		key_label.text = "-"
	else:
		key_label.text = events[0].as_text()
