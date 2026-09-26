class_name NPC
extends CharacterBody2D

@export var is_seller := false
@onready var shop_items: Control = $"../UI/ShopItems"

func talk() -> void:
	
	DialogueManager.show_dialogue_balloon(load("res://Dialogues/untitled.dialogue"), "start")
	
	if not is_seller:
		pass
		
		
	else:
		pass
		#if Dialogic.VAR.open_shop:
			#shop_items.show()
		#else:
			
		
	
