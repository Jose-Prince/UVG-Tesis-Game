class_name DateTime
extends Resource

@export_range(0, 59) var seconds: int = 0
@export_range(0, 59) var minutes: int = 0
@export_range(0, 23) var hours: int = 6
@export_range(1, 28) var days: int = 1
var delta_time: float = 0.0


func increase_by_sec(delta_seconds: float) -> void:
	delta_time += delta_seconds
	
	if delta_time < 1.0:
		return
	
	var delta_int_secs: int = int(delta_time)
	delta_time -= delta_int_secs
	
	seconds += delta_int_secs
	minutes += seconds / 60
	hours += minutes / 60

	seconds %= 60
	minutes %= 60

	if hours >= 22:
		hours = 22
		minutes = 0
		seconds = 0
	
		SaveManager.day_ended.emit()

func reset_to_start_of_day() -> void:
	hours = 6
	minutes = 0
	seconds = 0
	delta_time = 0.0

func diff_without_days(other_time: DateTime) -> int:
	var diff_hours := hours - other_time.hours
	var diff_minutes := minutes - other_time.minutes + diff_hours * 60
	var diff_seconds := seconds - other_time.seconds + diff_minutes * 60
	
	return diff_seconds
