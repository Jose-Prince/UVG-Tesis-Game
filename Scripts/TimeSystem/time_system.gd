class_name TimeSystem
extends Node

signal updated(date_time: DateTime)

var progress: bool = true

@export var date_time: DateTime
@export var ticks_pr_second: int = 6


func _ready() -> void:
	SaveManager.day_ended.connect(_on_day_ended)
	SaveManager.day_start.connect(_on_day_start)
	
	if date_time == null:
		date_time = DateTime.new()
	
	emit_time()

func _process(delta: float) -> void:
	if not progress:
		return
	
	date_time.increase_by_sec(delta * ticks_pr_second)
	updated.emit(date_time)

func _on_day_ended() -> void:
	progress = false

func _on_day_start() -> void:
	date_time.reset_to_start_of_day()
	progress = true
	
	emit_time()

func emit_time() -> void:
	if date_time:
		updated.emit(date_time)
