extends Node

signal shop_opened
signal shop_closed

var actual_hour: int = 0
var shop_was_open := false
var shop_initialized := false

@onready var hours: Label = $MarginContainer/HBoxContainer/PanelContainer/HBoxContainer/hours
@onready var space: Label = $MarginContainer/HBoxContainer/PanelContainer/HBoxContainer/space
@onready var minutes: Label = $MarginContainer/HBoxContainer/PanelContainer/HBoxContainer/minutes
@onready var period: Label = $MarginContainer/HBoxContainer/PanelContainer/HBoxContainer/period
@onready var clock_texture_rect: TextureRect = $MarginContainer/HBoxContainer/VBoxContainer/ClockClipping/ClockTextureRect

@onready var time_system: TimeSystem = $"../../../../../TimeSystem"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if time_system:
		time_system.updated.connect(_on_time_updated)

func _on_time_updated(date_time: DateTime) -> void:
	actual_hour = date_time.hours
	
	update_time_display(date_time)
	update_clock_rotation(date_time)
	update_shop_state()

func update_time_display(date_time: DateTime) -> void:
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

func update_clock_rotation(date_time: DateTime) -> void:
	var total_minutes := date_time.hours * 60 + date_time.minutes
	
	var minutes_from_noon := total_minutes - (12 * 60)
	
	if minutes_from_noon < 0:
		minutes_from_noon += 24 * 60
	
	var rotation_degrees := float(minutes_from_noon) / (24.0 * 60.0) * 360.0
	
	clock_texture_rect.rotation_degrees = rotation_degrees

func update_shop_state() -> void:
	var shop_is_open := GameData.is_shop_open(actual_hour)
	
	if not shop_initialized:
		shop_was_open = shop_is_open
		shop_initialized = true
		
		if shop_is_open:
			shop_opened.emit()
		else:
			shop_closed.emit()
		
		return
	
	if shop_is_open != shop_was_open:
		shop_was_open = shop_is_open
		
		if shop_is_open:
			shop_opened.emit()
		else:
			shop_closed.emit()
