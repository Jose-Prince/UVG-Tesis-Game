extends Control

@onready var action_label_title: Label = $VBoxContainer/HBoxContainer/ActionLabel
@onready var current_label_title: Label = $VBoxContainer/HBoxContainer/CurrentLabel
@onready var change_label_title: Label = $VBoxContainer/HBoxContainer/ChangeLabel

@onready var up_label: Label = $VBoxContainer/InputContainer/UpContainer/UpLabel
@onready var up_current_label: Label = $VBoxContainer/InputContainer/UpContainer/UpCurrentLabel
@onready var up_button: Button = $VBoxContainer/InputContainer/UpContainer/UpButton

@onready var down_label: Label = $VBoxContainer/InputContainer/DownContainer/DownLabel
@onready var down_current_label: Label = $VBoxContainer/InputContainer/DownContainer/DownCurrentLabel
@onready var down_button: Button = $VBoxContainer/InputContainer/DownContainer/DownButton

@onready var right_label: Label = $VBoxContainer/InputContainer/RightContainer/RightLabel
@onready var right_current_label: Label = $VBoxContainer/InputContainer/RightContainer/RightCurrentLabel
@onready var right_button: Button = $VBoxContainer/InputContainer/RightContainer/RightButton

@onready var left_label: Label = $VBoxContainer/InputContainer/LeftContainer/LeftLabel
@onready var left_current_label: Label = $VBoxContainer/InputContainer/LeftContainer/LeftCurrentLabel
@onready var left_button: Button = $VBoxContainer/InputContainer/LeftContainer/LeftButton

@onready var run_label: Label = $VBoxContainer/InputContainer/RunContainer/RunLabel
@onready var run_current_label: Label = $VBoxContainer/InputContainer/RunContainer/RunCurrentLabel
@onready var run_button: Button = $VBoxContainer/InputContainer/RunContainer/RunButton

@onready var action_label: Label = $VBoxContainer/InputContainer/ActionContainer/ActionLabel
@onready var action_current_label: Label = $VBoxContainer/InputContainer/ActionContainer/ActionCurrentLabel
@onready var action_button: Button = $VBoxContainer/InputContainer/ActionContainer/ActionButton

var waiting_action: String = ""

@onready var actions: Dictionary = {
	"up": [up_label, up_current_label, up_button],
	"down": [down_label, down_current_label, down_button],
	"right": [right_label, right_current_label, right_button],
	"left": [left_label, left_current_label, left_button],
	"run": [run_label, run_current_label, run_button],
	"action": [action_label, action_current_label, action_button]
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for action in actions.keys():
		var button: Button = actions[action][2]
		button.set_meta("action", action)
		button.pressed.connect(_on_change_button.bind(button))
		
		action_label_title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		current_label_title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		update_button_map(action)

func update_button_map(action: String) -> void:
	var action_label: Label = actions[action][0]
	var current_label: Label = actions[action][1]
	var change_button: Button = actions[action][2]
	
	action_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	current_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	change_button.set_meta("action", action)
	change_button.text = "Cambiar"
	
	var events = InputMap.action_get_events(action)
	
	if events.is_empty():
		action_label.text = "-"
		current_label.text = "-"
	else:
		current_label.text = events[0].as_text()

func _on_change_button(button: Button):
	waiting_action = button.get_meta("action")
	button.text = "..."

func _input(event: InputEvent) -> void:
	if waiting_action == "":
		return
		
	if event is InputEventKey and event.is_pressed():
		InputMap.action_erase_events(waiting_action)
		InputMap.action_add_event(waiting_action, event)
		
		update_button_map(waiting_action)
		
		waiting_action = ""
