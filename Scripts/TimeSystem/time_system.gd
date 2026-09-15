class_name TimeSystem extends Node

signal updated(date_time: DateTime)

var progress: bool = true

@export var date_time: DateTime
@export var ticks_pr_second: int = 6

func _ready() -> void:
	SaveManager.day_ended.connect(restart_day)
	SaveManager.day_ended.connect(change_progress)
	SaveManager.day_start.connect(change_progress)
	
func _process(delta: float) -> void:
	if progress:
		date_time.increase_by_sec(delta * ticks_pr_second)
		updated.emit(date_time)

func restart_day() -> void:
	date_time.hours = 6
	date_time.minutes = 0
	date_time.seconds = 0

func change_progress() -> void:
	progress = !progress
