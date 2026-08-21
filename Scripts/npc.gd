class_name NPC
extends CharacterBody2D

var player_in_range := false

@export var dialogic := true

@export var npc_name := "Cliente"
@export var dialogue_text := "¡Este lugar está que flipas, manin!."
@export var portrait: Texture2D

func talk() -> void:
	if dialogic:
		Dialogic.start("example_timeline")
	else:
		DialogueBox.show_dialogue(npc_name, dialogue_text, preload("uid://nxlljthxlqp5"))
