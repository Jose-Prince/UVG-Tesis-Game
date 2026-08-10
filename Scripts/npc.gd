class_name NPC
extends CharacterBody2D

var player_in_range := false

@onready var dialogue: CanvasLayer = $"../DialogueBubble"

@export var npc_name := "Cliente"
@export var dialogue_text := "¡Este lugar está que flipas, manin!."
@export var portrait: Texture2D

func talk() -> void:
	print(npc_name, " está hablando...")
	dialogue.show()
	DialogueBubble.show_dialogue(dialogue_text, "portrait")
	
func untalk() -> void:
	dialogue.hide()
