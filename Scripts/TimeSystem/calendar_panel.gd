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

var scene_transition: Node

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
	
	scene_transition = get_tree().root.find_child("SceneTransition", true, false)
	SaveManager.day_ended.connect(_on_day_ended)
	
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
			"popularity": GameData.popularity,
			"appearance": {
				"skin_color": GameData.player_skin_color,
				"hair_color": GameData.player_hair_color,
				"hair_style": GameData.player_hair_style,
				"shirt_style": GameData.player_shirt_style,
				"shirt_color": GameData.player_shirt_color,
				"pants_style": GameData.player_pants_style,
				"pants_color": GameData.player_pants_color,
			}
		}
	)
	
	GameData.day_index = (current_day_index + 1) % days.size()
	GameData.num_day = current_day_number + 1
	GameData.month = actual_month
	GameData.year = 1
	
	await scene_transition.pixelate_in(0.6).finished
	get_tree().change_scene_to_file("res://Scenes/new_day.tscn")
