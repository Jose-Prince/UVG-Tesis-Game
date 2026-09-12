class_name NPC
extends CharacterBody2D

@export var is_seller := false
@onready var shop_items: Control = $"../UI/ShopItems"

func talk() -> void:
	if not is_seller:
		Dialogic.start("example_timeline")
	else:
		GameData.is_shopping = true
		Dialogic.start("shop_timeline")
		shop_items.show()
		shop_items.grab_focus()
