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
	print("")
	print("========== PURCHASE DEBUG ==========")
	print("Requested item: ", item_id)
	print("Current money: $", PlayerData.money)

	var item_data := get_item_data(item_id)

	if item_data.is_empty():
		print("[SHOP] ERROR: Item does not exist.")
		print("====================================")
		return

	var price: float = item_data["price"]

	print("Item price: $", price)

	if not PlayerData.can_afford(price):
		print("[SHOP] Purchase FAILED: Not enough money.")
		print("====================================")
		return

	if not PlayerData.spend_money(price):
		print("[SHOP] Purchase FAILED: spend_money() returned false.")
		print("====================================")
		return

	FurnitureInventory.add_item(item_id)

	print("[SHOP] Purchase SUCCESSFUL!")
	print("Item: ", item_id)
	print("Price: $", price)
	print("Remaining money: $", PlayerData.money)
	print(
		"Inventory quantity: ",
		FurnitureInventory.get_item_count(item_id)
	)

	FurnitureInventory.debug_print_inventory()

	print("====================================")
	print("")

	update_money_display()


func get_item_data(item_id: String) -> Dictionary:
	match item_id:
		"wooden_table":
			return {
				"price": 100.0
			}

		"wooden_chair":
			return {
				"price": 50.0
			}

	return {}

func _on_close_button_pressed() -> void:
	hide_shop()


func _on_furniture_shop_item_2_purchase_requested(item_id: String) -> void:
	pass # Replace with function body.
