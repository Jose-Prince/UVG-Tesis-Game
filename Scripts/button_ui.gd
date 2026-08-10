class_name UIButton
extends Button

func _ready() -> void:
	pressed.connect(SfxManager.play_click)
