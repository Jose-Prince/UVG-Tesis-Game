class_name ShopNPC
extends Interactable


@export var shop_ui: Control


func interact() -> void:
	if shop_ui:
		shop_ui.show_shop()
