extends Control

var start_month := 0
var start_day := 1
var start_weekday := 0

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

func _ready() -> void:
	var date = Time.get_datetime_dict_from_system()
	
	start_month = date["month"] - 1
	start_day = date["day"]
	start_weekday = date["weekday"]
	
	SaveManager.day_ended.connect(_on_day_ended)

func add_point(moneyRecived: int):
	money += moneyRecived
	money_count.text = str(money)

func _on_time_system_updated(date_time: DateTime) -> void:
	var total_days := (start_day - 1) + (date_time.days - 1)
	
	var current_day := ((total_days - 1) % 30) + 1
	update_label(day, current_day)
	
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
	
	var day_index := (start_weekday + date_time.days - 1) & days.size()
	day_name.text = days[day_index]
	
	var month_index := (start_month + int(total_days / 30)) % months.size()
	month.text = months[month_index]

func add_leading_zero(label: Label, value: int) -> void:
	if value < 10:
		label.text += '0'
		
func update_label(label: Label, value: int, should_have_zero: bool = true) -> void:
	label.text = ""
		
	if should_have_zero:
		add_leading_zero(label, value)
			
	label.text += str(value)

func _on_day_ended():
	SaveManager.save_game(1, {"Day": day.text, "Month": month.text, "Money": money_count.text})
