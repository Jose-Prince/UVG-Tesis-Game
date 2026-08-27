extends Control

const INPUT_ROW_SCENE = preload("res://Prefabs/InputRow.tscn")

@onready var input_container: VBoxContainer = $VBoxContainer/ScrollContainer/InputContainer

var waiting_action: String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for action in InputMap.get_actions():
		if action.begins_with("ui_") or action.begins_with("dialogic_"):
			continue

		var input_row = INPUT_ROW_SCENE.instantiate()
		
		input_container.add_child(input_row)
		input_row.setup(action)
		#var button: Button = actions[action][2]
		#button.set_meta("action", action)
		#button.pressed.connect(_on_change_button.bind(button))
		#
		#action_label_title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		#current_label_title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		#update_button_map(action)

#func update_button_map(action: String) -> void:
	#var action_label: Label = actions[action][0]
	#var current_label: Label = actions[action][1]
	#var change_button: Button = actions[action][2]
	#
	#action_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	#current_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	#
	#change_button.set_meta("action", action)
	#change_button.text = "Cambiar"
	#
	#var events = InputMap.action_get_events(action)
	#
	#if events.is_empty():
		#action_label.text = "-"
		#current_label.text = "-"
	#else:
		#current_label.text = events[0].as_text()
#
#func _on_change_button(button: Button):
	#waiting_action = button.get_meta("action")
	#button.text = "..."
#
#func _input(event: InputEvent) -> void:
	#if waiting_action == "":
		#return
		#
	#if event is InputEventKey and event.is_pressed():
		#InputMap.action_erase_events(waiting_action)
		#InputMap.action_add_event(waiting_action, event)
		#
		#update_button_map(waiting_action)
		#
		#waiting_action = ""
