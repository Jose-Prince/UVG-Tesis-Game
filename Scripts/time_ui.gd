extends Control

var start_month: int
var start_day: int
var day_index: int

var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "Decemmber"]
var days = ["Mon.", "Tue.", "Wed.", "Thu.", "Fri.", "Sat.", "Sun."]
var money: int = 0

var actual_month: int

@onready var day: Label = $DayControl/days
@onready var hours: Label = $ClockControl/hours
@onready var minutes: Label = $ClockControl/minutes
@onready var money_count: Label = $MoneyControl/MoneyCount
@onready var periodLabel: Label = $ClockControl/period
@onready var day_name: Label = $DayControl/dayName
@onready var month: Label = $MonthControl/Month

func _ready() -> void:
	var date = Time.get_datetime_dict_from_system()
	
	start_month = GameData.month
	start_day = GameData.num_day
	day_index = GameData.day_index
	
	SaveManager.day_ended.connect(_on_day_ended)

func add_point(moneyRecived: int):
	money += moneyRecived
	money_count.text = str(money)

func _on_time_system_updated(date_time: DateTime) -> void:
	var total_days := (start_day) + (date_time.days - 1)
	
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
	
	var day_index := (day_index + date_time.days - 1) % days.size()
	day_name.text = days[day_index]
	
	var month_index := (start_month + int(total_days / 30)) % months.size()
	actual_month = month_index
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
	print("Save")
	SaveManager.save_especific_data(GameData.game_slot, "world", {"day_index": day_index, "num_day": int(day.text), "month": actual_month, "year": 0})
