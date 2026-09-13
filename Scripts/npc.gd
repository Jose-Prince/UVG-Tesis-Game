class_name NPC
extends CharacterBody2D

@export var is_seller := false
@onready var shop_items: Control = $"../UI/ShopItems"

func talk() -> void:
	GameData.process_time = false
	if not is_seller:
		Dialogic.start("example_timeline")
	else:
		Dialogic.start("shop_timeline")
		
		await Dialogic.timeline_ended
		
		if Dialogic.VAR.open_shop:
			shop_items.show()
		else:
			GameData.process_time = true
		
	
