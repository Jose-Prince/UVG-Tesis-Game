extends CanvasLayer

@onready var text_label: RichTextLabel = $Control/HBoxContainer/ColorRect/Text
@onready var portrait_rect: TextureRect = $Control/Portrait

func show_dialogue(text: String, portrait: String) -> void:
	if text_label:
		text_label.text = text
	var tween = create_tween()
	var duration = text.length() * 0.03
	tween.tween_property(text_label, "visible_characters", text.length(), duration)
