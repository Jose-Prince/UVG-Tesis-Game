class_name NPC
extends CharacterBody2D

@export var is_seller := false
@onready var shop_items: Control = $"../UI/ShopItems"

func talk() -> void:
	GameData.process_time = false
	if not is_seller:
		GameData.process_time = true
	else:
		pass
		#if Dialogic.VAR.open_shop:
			#shop_items.show()
		#else:
			#GameData.process_time = true
		
	
