class_name TimeSystem extends Node

signal updated

var progress: bool = true

@export var date_time: DateTime
@export var ticks_pr_second: int = 6

func _ready() -> void:
	SaveManager.day_ended.connect(change_progress)

func _process(delta: float) -> void:
	if progress:
		date_time.increase_by_sec(delta * ticks_pr_second)
		updated.emit(date_time)

func change_progress():
	progress = !progress
	print("Tiempo parado")
