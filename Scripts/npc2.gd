class_name NPC2
extends CharacterBody2D

var player_in_range := false

@export var npc_name := "Cliente"
@export var dialogue_text := "¡Este lugar está que flipas, manin!."
@export var portrait: Texture2D

func talk() -> void:
	#Dialogic.start("example_timeline")
	DialogueBox.show_dialogue("Steve", "Hello", preload("uid://nxlljthxlqp5"))
