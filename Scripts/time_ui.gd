extends Control

var start_month: int
var start_day: int
var day_index: int
var year: int

var current_day_number: int
var current_day_index: int

var actual_hour: int = 0

var months = [
	"January", "February", "March", "April",
	"May", "June", "July", "August",
	"September", "October", "November", "Decemmber"
]

var days = [
	"Mon.", "Tue.", "Wed.", "Thu.",
	"Fri.", "Sat.", "Sun."
]

var actual_month: int

var scene_transition: Node

@onready var month: Label = $Panel/MarginContainer/VBoxContainer/MonthContainer/MarginContainer/PanelContainer/Month
@onready var day_name: Label = $Panel/MarginContainer/VBoxContainer/DayContainer/MarginContainer/HBoxContainer/PanelContainer/dayName
@onready var day: Label = $Panel/MarginContainer/VBoxContainer/DayContainer/MarginContainer/HBoxContainer/PanelContainer2/day
@onready var hours: Label = $Panel/MarginContainer/VBoxContainer/HourContainer/MarginContainer/PanelContainer/CenterContainer/HBoxContainer/hours
@onready var space: Label = $Panel/MarginContainer/VBoxContainer/HourContainer/MarginContainer/PanelContainer/CenterContainer/HBoxContainer/space
@onready var minutes: Label = $Panel/MarginContainer/VBoxContainer/HourContainer/MarginContainer/PanelContainer/CenterContainer/HBoxContainer/minutes
@onready var period_label: Label = $Panel/MarginContainer/VBoxContainer/HourContainer/MarginContainer/PanelContainer/CenterContainer/HBoxContainer/period

@onready var tens_of_thousand: Label = $Panel/MarginContainer/VBoxContainer/MoneyContainer/MarginContainer/HBoxContainer/PanelContainer2/HBoxContainer/TensOfThousand
@onready var thousand_unit: Label = $Panel/MarginContainer/VBoxContainer/MoneyContainer/MarginContainer/HBoxContainer/PanelContainer2/HBoxContainer/ThousandUnit
@onready var hundred: Label = $Panel/MarginContainer/VBoxContainer/MoneyContainer/MarginContainer/HBoxContainer/PanelContainer2/HBoxContainer/Hundred
@onready var ten: Label = $Panel/MarginContainer/VBoxContainer/MoneyContainer/MarginContainer/HBoxContainer/PanelContainer2/HBoxContainer/Ten
@onready var unit: Label = $Panel/MarginContainer/VBoxContainer/MoneyContainer/MarginContainer/HBoxContainer/PanelContainer2/HBoxContainer/Unit
@onready var decimal_1: Label = $Panel/MarginContainer/VBoxContainer/MoneyContainer/MarginContainer/HBoxContainer/PanelContainer2/HBoxContainer/Decimal1
@onready var decimal_2: Label = $Panel/MarginContainer/VBoxContainer/MoneyContainer/MarginContainer/HBoxContainer/PanelContainer2/HBoxContainer/Decimal2

func _ready() -> void:
	start_month = GameData.month
	start_day = GameData.num_day
	day_index = GameData.day_index
	year = GameData.year

	current_day_index = day_index
	current_day_number = start_day
	
	update_money_display()
	
	SaveManager.day_ended.connect(_on_day_ended)
	
	scene_transition = get_tree().root.find_child("SceneTransition", true, false)

func add_point(money_received: float) -> void:
	print(money_received)
	GameData.money += money_received
	SfxManager.play_money()
	update_money_display()

func _on_time_system_updated(date_time: DateTime) -> void:
	var total_days := start_day + (date_time.days - 1)

	current_day_number = ((total_days - 1) % 30) + 1
	update_label(day, current_day_number)

	actual_hour = date_time.hours
	var display_hour := date_time.hours
	var period := "AM"

	if display_hour >= 12:
		period = "PM"

	if display_hour > 12:
		display_hour -= 12

	update_label(hours, display_hour)

	var display_minutes := int(date_time.minutes / 5) * 5
	update_label(minutes, display_minutes)

	period_label.text = period

	current_day_index = (day_index + date_time.days - 1) % days.size()
	day_name.text = days[current_day_index]

	actual_month = (start_month + int(total_days / 30)) % months.size()
	month.text = months[actual_month]

func add_leading_zero(label: Label, value: int) -> void:
	if value < 10:
		label.text += "0"

func update_label(label: Label, value: int, should_have_zero: bool = true) -> void:
	label.text = ""

	if should_have_zero:
		add_leading_zero(label, value)

	label.text += str(value)

func update_money_display():
	var money_string := "%.2f" % GameData.money

	money_string = money_string.replace(".", "")

	money_string = money_string.pad_zeros(7)

	tens_of_thousand.text = money_string[0]
	thousand_unit.text = money_string[1]
	hundred.text = money_string[2]
	ten.text = money_string[3]
	unit.text = money_string[4]
	decimal_1.text = money_string[5]
	decimal_2.text = money_string[6]
	

func _on_day_ended() -> void:
	SaveManager.save_especific_data(
		GameData.game_slot,
		"world",
		{
			"day_index": (current_day_index + 1) % days.size(),
			"num_day": current_day_number + 1,
			"month": actual_month,
			"year": GameData.year
		}
	)
	
	SaveManager.save_especific_data(
		GameData.game_slot,
		"player",
		{
			"name": GameData.player_name,
			"money": GameData.money,
			"popularity": GameData.popularity
		}
	)
	
	GameData.day_index = (current_day_index + 1) % days.size()
	GameData.num_day = current_day_number + 1
	GameData.month = actual_month
	GameData.year = year
	
	await scene_transition.pixelate_in(0.6).finished
	get_tree().change_scene_to_file("res://Scenes/new_day.tscn")
