extends Panel

@onready var play_button: Button = $MarginContainer/HBoxContainer/PlayButton
@onready var x_2_button: Button = $MarginContainer/HBoxContainer/x2Button
@onready var x_3_button: Button = $MarginContainer/HBoxContainer/x3Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play_button.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_button_pressed() -> void:
	play_button.grab_focus()
	Engine.time_scale = 1.0
	SfxManager.play_click()


func _on_x_2_button_pressed() -> void:
	x_2_button.grab_focus()
	Engine.time_scale = 2.0
	SfxManager.play_click()

func _on_x_3_button_pressed() -> void:
	x_3_button.grab_focus()
	Engine.time_scale = 3.0
	SfxManager.play_click()
