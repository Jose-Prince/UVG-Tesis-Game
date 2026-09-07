extends Node

# =========================
# GAME STATE
# =========================

var money: float = 500.0
var reputation: float = 0.0

var current_day: int = 1
var day_progress: float = 0.0


# =========================
# CAFÉ STATE
# =========================

var cafe_open: bool = false


# =========================
# TIME
# =========================

@export var day_duration: float = 600.0


func _process(delta: float) -> void:
	if cafe_open:
		update_time(delta)


func update_time(delta: float) -> void:
	day_progress += (delta / day_duration) * 100.0
	
	if day_progress >= 100.0:
		end_day()


func end_day() -> void:
	day_progress = 0.0
	current_day += 1
	
	print("New day: ", current_day)
