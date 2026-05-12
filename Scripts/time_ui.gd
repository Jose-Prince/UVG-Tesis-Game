extends Control

var money: int = 0

@onready var days: Label = $DayControl/days
@onready var hours: Label = $ClockControl/hours
@onready var minutes: Label = $ClockControl/minutes
@onready var money_count: Label = $MoneyControl/MoneyCount

func add_point():
	money += 1
	money_count.text = str(money)

func _on_time_system_updated(date_time: DateTime) -> void:
	update_label(days, date_time.days)
	update_label(hours, date_time.hours)
	update_label(minutes, date_time.minutes)

func add_leading_zero(label: Label, value: int) -> void:
	if value < 10:
		label.text += '0'
		
func update_label(label: Label, value: int, should_have_zero: bool = true) -> void:
	label.text = ""
		
	if should_have_zero:
		add_leading_zero(label, value)
			
	label.text += str(value)
