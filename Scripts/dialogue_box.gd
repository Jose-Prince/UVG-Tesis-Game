extends CanvasLayer

@onready var portrait: TextureRect = $CharacterPortrait
@onready var name_label: Label = $NameBox/NameLabel
@onready var dialogue_label: Label = $DialoguePanel/DialogueLabel

func _ready() -> void:
	visible = false

func show_dialogue(character_name: String, text: String, portrait_texture: Texture2D = null):
	name_label.text = character_name
	dialogue_label.text = text
	if portrait_texture:
		portrait.texture = portrait_texture
		portrait.visible = true
	else:
		portrait.visible = false
	visible = true

func hide_dialogue():
	visible = false
