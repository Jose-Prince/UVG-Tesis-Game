class_name ShopUI
extends Control


@onready var money_label: Label = $Overlay/ShopPanel/MarginContainer/VBoxContainer/Footer/MoneyLabel


func _ready() -> void:
	hide()
	update_money_display()


func show_shop() -> void:
	update_money_display()
	show()


func hide_shop() -> void:
	hide()


func update_money_display() -> void:
	money_label.text = "Money: $" + str(PlayerData.money)


func _on_furniture_shop_item_purchase_requested(item_id: String) -> void:
	var item_data := get_item_data(item_id)

	if item_data.is_empty():
		return

	var price: int = item_data["price"]

	if not PlayerData.spend_money(price):
		print("Not enough money to buy: ", item_id)
		return

	print(
		"Purchased: ",
		item_id,
		" | Spent: $",
		price,
		" | Remaining: $",
		PlayerData.money
	)

	update_money_display()


func get_item_data(item_id: String) -> Dictionary:
	match item_id:
		"wooden_table":
			return {
				"price": 100
			}

		"wooden_chair":
			return {
				"price": 50
			}

	return {}


func _on_close_button_pressed() -> void:
	hide_shop()
