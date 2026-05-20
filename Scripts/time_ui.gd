extends Control

var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "Decemmber"]
var days = ["Mon.", "Tue.", "Wed.", "Thu.", "Fri.", "Sat.", "Sun."]
var money: int = 0

@onready var day: Label = $DayControl/days
@onready var hours: Label = $ClockControl/hours
@onready var minutes: Label = $ClockControl/minutes
@onready var money_count: Label = $MoneyControl/MoneyCount
@onready var periodLabel: Label = $ClockControl/period
@onready var day_name: Label = $DayControl/dayName
@onready var month: Label = $MonthControl/Month

func add_point():
	money += 1
	money_count.text = str(money)

func _on_time_system_updated(date_time: DateTime) -> void:
	update_label(days, date_time.days)
	
	var display_hour := date_time.hours
	var period := "AM"
	
	if display_hour >= 12:
		period = "PM"
		
	if display_hour > 12:
		display_hour -= 12
	
	update_label(hours, display_hour)
	update_label(minutes, date_time.minutes)
	
	periodLabel.text = period

func add_leading_zero(label: Label, value: int) -> void:
	if value < 10:
		label.text += '0'
		
func update_label(label: Label, value: int, should_have_zero: bool = true) -> void:
	label.text = ""
		
	if should_have_zero:
		add_leading_zero(label, value)
			
	label.text += str(value)
