class_name  MinMaxButton 
extends Control

signal pressed(value: int)

@export var text := ""
@export var max_value := 100
@export var min_value := 0
@export var increment := 5
@onready var line_edit: LineEdit = $LineEdit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	line_edit.text = text

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _get_numeric_value() -> int:
	var numbers := ""

	for c: String in line_edit.text:
		if c.is_valid_int():
			numbers += c

	if numbers.is_empty():
		return min_value

	return int(numbers)

func _gui_input(event):
	if event.is_action_pressed("ui_left"):
		_on_minus_button_pressed()
		accept_event()
	
	elif event.is_action_pressed("ui_right"):
		_on_plus_button_pressed()
		accept_event()

func _set_numeric_value(value: int) -> void:
	var text := line_edit.text

	var start := -1
	var end := -1

	for i in text.length():
		if text[i].is_valid_int():
			if start == -1:
				start = i
			end = i

	if start == -1:
		line_edit.text = str(value)
		return

	var prefix := text.substr(0, start)
	var suffix := text.substr(end + 1)

	line_edit.text = prefix + str(value) + suffix

func _on_minus_button_pressed() -> void:
	var value := maxi(_get_numeric_value() - increment, min_value)
	_set_numeric_value(value)
	emit_signal("pressed", value)

func _on_plus_button_pressed() -> void:
	var value := mini(_get_numeric_value() + increment, max_value)
	_set_numeric_value(value)
	emit_signal("pressed", value)
