class_name FoodVisual
extends Node2D


var order: CustomerOrder = null


func setup(order_data: CustomerOrder) -> void:
	order = order_data

	if order == null:
		return

	update_visual()


func update_visual() -> void:
	var color_rect := $ColorRect as ColorRect

	match order.item_name:
		"Coffee":
			color_rect.color = Color("#6b3e26")

		"Latte":
			color_rect.color = Color("#c49a6c")

		"Cappuccino":
			color_rect.color = Color("#a8754f")

		"Cake":
			color_rect.color = Color("#e6a5a5")

		_:
			color_rect.color = Color.WHITE
