extends DirectionalLight2D

@export var day_color: Color
@export var night_color: Color
@export var day_start: DateTime
@export var night_start: DateTime
@export var transition_time: int = 60 # minutos

enum DayStates {
	DAY,
	NIGHT
}

var current_state: DayStates = DayStates.DAY
var in_transition: bool = false
var time_system: TimeSystem

@onready var time_map := {
	DayStates.DAY: day_start,
	DayStates.NIGHT: night_start
}

@onready var transition_map := {
	DayStates.DAY: DayStates.NIGHT,
	DayStates.NIGHT: DayStates.DAY
}

@onready var color_map := {
	DayStates.DAY: day_color,
	DayStates.NIGHT: night_color
}

func _ready() -> void:
	time_system = get_tree().root.find_child("TimeSystem", true, false)

	if time_system:
		time_system.updated.connect(update)
		var diff_day_start = time_system.date_time.diff_without_days(day_start)
		var diff_night_start = time_system.date_time.diff_without_days(night_start)
		
		if diff_day_start < 0 || diff_night_start > 0:
			current_state = DayStates.NIGHT
		

func update(game_time: DateTime) -> void:
	var next_state: DayStates = transition_map[current_state]
	var change_time: DateTime = time_map[next_state]

	var time_diff: int = change_time.diff_without_days(game_time)
	
	if game_time == day_start && current_state == DayStates.NIGHT:
		current_state = next_state
		in_transition = false
		color = color_map[current_state]
		return
	
	if in_transition:
		update_transition(time_diff, next_state)
	elif time_diff > 0 and time_diff < (transition_time * 60):
		in_transition = true
		update_transition(time_diff, next_state)
	else:
		color = color_map[current_state]

func update_transition(time_diff: int, next_state: DayStates) -> void:
	var ratio = 1 - (time_diff as float / (transition_time * 60))
	
	if ratio > 1.0:
		current_state = next_state
		in_transition = false
	else:
		color = color_map[current_state].lerp(
			color_map[next_state],
			clamp(ratio, 0.0, 1.0)
		)
