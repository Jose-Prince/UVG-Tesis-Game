extends Panel

var start_month: int
var start_day: int
var day_index: int

var current_day_number: int
var current_day_index: int
var actual_month: int

var months = [
	"Jan", "Feb", "Mar", "Apr",
	"May", "Jun", "Jul", "Aug",
	"Sep", "Oct", "Nov", "Dec"
]

var days = [
	"Mon", "Tue", "Wed", "Thu",
	"Fri", "Sat", "Sun"
]

@onready var month_label: Label = $MarginContainer/HBoxContainer/MonthLabel
@onready var day_name: Label = $MarginContainer/HBoxContainer/HBoxContainer/DisplayPanelContainer/HBoxContainer/DayName
@onready var day: Label = $MarginContainer/HBoxContainer/HBoxContainer/DisplayPanelContainer/HBoxContainer/Day

@onready var time_system: TimeSystem = $"../../../../TimeSystem"


func _ready() -> void:
	start_month = GameData.month
	start_day = GameData.num_day
	day_index = GameData.day_index
	
	current_day_number = start_day
	current_day_index = day_index
	actual_month = start_month
	
	if time_system:
		time_system.updated.connect(_on_time_updated)

func _on_time_updated(date_time: DateTime) -> void:
	var total_days := start_day + (date_time.days - 1)
	
	current_day_number = ((total_days - 1) % 30) + 1
	day.text = "%02d" % current_day_number
	
	current_day_index = (day_index + date_time.days - 1) % days.size()
	day_name.text = days[current_day_index]
	
	actual_month = (start_month + int(total_days / 30)) % months.size()
	month_label.text = months[actual_month]
