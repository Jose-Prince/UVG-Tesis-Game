extends Node

signal updated(date_time: DateTime)

var time_paused := false

@export var date_time: DateTime
@export var ticks_pr_second: int = 6

func _ready() -> void:
	pause_time()

func _process(delta: float) -> void:
	if time_paused:
		return
	
	date_time.increase_by_sec(delta * ticks_pr_second)
	updated.emit(date_time)

func restart_day() -> void:
	date_time.hours = 6
	date_time.minutes = 0
	date_time.seconds = 0

func resume_time() -> void:
	time_paused = false

func pause_time() -> void:
	time_paused = true
