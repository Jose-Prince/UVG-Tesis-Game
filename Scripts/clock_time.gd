extends Node

var actual_hour: int = 0

@onready var time_system: TimeSystem = $"../../../../TimeSystem"
@onready var hours: Label = $MarginContainer/HBoxContainer/PanelContainer/HBoxContainer/hours
@onready var space: Label = $MarginContainer/HBoxContainer/PanelContainer/HBoxContainer/space
@onready var minutes: Label = $MarginContainer/HBoxContainer/PanelContainer/HBoxContainer/minutes
@onready var period: Label = $MarginContainer/HBoxContainer/PanelContainer/HBoxContainer/period

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if time_system:
		time_system.updated.connect(_on_time_updated)

func _on_time_updated(date_time: DateTime) -> void:
	var display_hour := date_time.hours
	var display_period := "AM"
	
	if display_hour >= 12:
		display_period = "PM"
	
	if display_hour > 12:
		display_hour -= 12
	
	if display_hour == 0:
		display_hour = 12
	
	update_label(hours, display_hour)
	
	var display_minutes := int(date_time.minutes / 5) * 5
	update_label(minutes, display_minutes)
	
	period.text = display_period
	
func update_label(label: Label, value: int, should_have_zero: bool = true) -> void:
	if should_have_zero:
		label.text = "%02d" % value
	else:
		label.text = str(value)
