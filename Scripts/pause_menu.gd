extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("PAUSE MENU READY")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_continue_button_pressed() -> void:
	get_tree().paused = false
	print("CONTINUE CLICKED")
	hide()

func _on_return_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")
