class_name NPC
extends CharacterBody2D

@export var is_seller := false
@onready var shop_items: Control = $"../UI/ShopItems"

func talk() -> void:
	DialogueManager.show_dialogue_balloon(load("res://Dialogues/seller_dialogue.dialogue"), "start")
	
	await DialogueManager.dialogue_ended
	
	shop_items.show()
