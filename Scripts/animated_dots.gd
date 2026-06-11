extends Label

@export var base_text := "Saving game"

var dots := 0

func _ready():
	var timer := Timer.new()
	timer.wait_time = 0.4
	timer.timeout.connect(_on_timer_timeout)
	timer.autostart = true
	add_child(timer)

func set_base_text(new_text: String):
	base_text = new_text
	text = new_text

func _on_timer_timeout():
	if self.text != base_text:
		dots = (dots + 1) % 4
		text = base_text + ".".repeat(dots)
