extends Node

signal updated(date_time: DateTime)

var progress: bool = false

@export var date_time: DateTime
@export var ticks_pr_second: int = 6

func _process(delta: float) -> void:
	if progress:
		date_time.increase_by_sec(delta * ticks_pr_second)
		updated.emit(date_time)

func restart_day() -> void:
	date_time.hours = 6
	date_time.minutes = 0
	date_time.seconds = 0
