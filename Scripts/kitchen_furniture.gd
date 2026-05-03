extends Area2D

func _ready() -> void:
	input_event.connect(_on_input_event)
	
func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed && event.button_index == MOUSE_BUTTON_LEFT:
			print("clic")
