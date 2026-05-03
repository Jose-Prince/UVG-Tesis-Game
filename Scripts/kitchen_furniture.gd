extends Area2D

var clickable = false

func _ready() -> void:
	input_event.connect(_on_input_event)
	
func _on_input_event(viewport, event, shape_idx):
	if clickable:
		if event is InputEventMouseButton:
			if event.pressed && event.button_index == MOUSE_BUTTON_LEFT:
				print("click: " + str(clickable))

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		clickable = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		clickable = false
