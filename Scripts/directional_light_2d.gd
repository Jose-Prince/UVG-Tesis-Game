extends DirectionalLight2D

@export var day_color: Color
@export var night_color: Color
@export var day_start: DateTime
@export var night_start: DateTime
@export var transition_time: int = 30 #in minutes

enum DayStates {
	DAY,
	NIGHT
}
var current_state: DayStates
var in_transition: bool = false

@onready var time_map: Dictionary = {
	DayStates.DAY: day_start,
	DayStates.NIGHT: night_start
}

@onready var transition_map: Dictionary = {
	DayStates.DAY: DayStates.NIGHT,
	DayStates.NIGHT: DayStates.DAY
}

@onready var color_map: Dictionary = {
	DayStates.DAY: day_color,
	DayStates.NIGHT: night_color
}

func update(game_time: DateTime) -> void:
	var next_state = transition_map[current_state]
	var change_time = time_map[next_state]
	var time_diff = change_time.diff_without_days(game_time)
	
	if time_diff > 0 && time_diff < (transition_time * 60):
		in_transition = true
		

func update_transition(time_diff: int, next_state: DayStates) -> void:
	var ratio = 1 - (time_diff as float / (transition_time * 60))
	if ratio > 1:
		current_state = next_state
		in_transition = false
	else:
		color = color_map[current_state].lerp(color_map[next_state], ratio)
		
