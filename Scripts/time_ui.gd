extends Control

var start_month: int
var start_day: int
var day_index: int
var year: int

var current_day_number: int
var current_day_index: int

var months = [
	"January", "February", "March", "April",
	"May", "June", "July", "August",
	"September", "October", "November", "Decemmber"
]

var days = [
	"Mon.", "Tue.", "Wed.", "Thu.",
	"Fri.", "Sat.", "Sun."
]

var money: int = 0
var actual_month: int

var scene_transition: Node

@onready var day: Label = $DayControl/days
@onready var hours: Label = $ClockControl/hours
@onready var minutes: Label = $ClockControl/minutes
@onready var money_count: Label = $MoneyControl/MoneyCount
@onready var periodLabel: Label = $ClockControl/period
@onready var day_name: Label = $DayControl/dayName
@onready var month: Label = $MonthControl/Month

func _ready() -> void:
	start_month = GameData.month
	start_day = GameData.num_day
	day_index = GameData.day_index
	year = GameData.year

	current_day_index = day_index
	current_day_number = start_day

	SaveManager.day_ended.connect(_on_day_ended)
	
	scene_transition = get_tree().root.find_child("SceneTransition", true, false)

func add_point(money_received: int) -> void:
	money += money_received
	money_count.text = str(money)

func _on_time_system_updated(date_time: DateTime) -> void:
	var total_days := start_day + (date_time.days - 1)

	current_day_number = ((total_days - 1) % 30) + 1
	update_label(day, current_day_number)

	var display_hour := date_time.hours
	var period := "AM"

	if display_hour >= 12:
		period = "PM"

	if display_hour > 12:
		display_hour -= 12

	update_label(hours, display_hour)

	var display_minutes := int(date_time.minutes / 5) * 5
	update_label(minutes, display_minutes)

	periodLabel.text = period

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
			"money": money,
			"popularity": GameData.popularity
		}
	)
	
	GameData.day_index = (current_day_index + 1) % days.size()
	GameData.num_day = current_day_number + 1
	GameData.month = actual_month
	GameData.year = year
	
	await scene_transition.pixelate_in(0.6).finished
	get_tree().change_scene_to_file("res://Scenes/new_day.tscn")
