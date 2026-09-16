extends Panel

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

func _ready() -> void:
	scene_transition = get_tree().root.find_child("SceneTransition", true, false)
	SaveManager.day_ended.connect(_on_day_ended)
	
	update_calendar()

func update_calendar() -> void:
	month_label.text = months[GameData.month]
	day_name.text = days[GameData.day_index]
	day.text = "%02d" % GameData.num_day

func _on_day_ended() -> void:
	TimeSystem.restart_day()

	GameData.day_index = (GameData.day_index + 1) % days.size()
	GameData.num_day += 1
	
	if GameData.num_day > 28:
		GameData.num_day = 1
		GameData.month += 1
		
		if GameData.month >= 12:
			GameData.month = 0
			GameData.year += 1
	
	SaveManager.save_especific_data(
		GameData.game_slot,
		"world",
		{
			"day_index": GameData.day_index,
			"num_day": GameData.num_day,
			"month": GameData.month,
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
	
	await scene_transition.pixelate_in(0.6).finished
	get_tree().change_scene_to_file("res://Scenes/new_day.tscn")
