extends Node

signal inventory_changed

var items: Dictionary = {}


func add_item(item_id: String, amount: int = 1) -> void:
	if item_id.is_empty() or amount <= 0:
		return

	if items.has(item_id):
		items[item_id] += amount
	else:
		items[item_id] = amount

	print(
		"[INVENTORY] Added: ",
		item_id,
		" x",
		amount,
		" | Total: ",
		items[item_id]
	)

	inventory_changed.emit()


func remove_item(item_id: String, amount: int = 1) -> bool:
	if not items.has(item_id):
		return false

	if amount <= 0 or items[item_id] < amount:
		return false

	items[item_id] -= amount

	if items[item_id] <= 0:
		items.erase(item_id)

	print(
		"[INVENTORY] Removed: ",
		item_id,
		" x",
		amount
	)

	inventory_changed.emit()

	return true

func has_item(item_id: String, amount: int = 1) -> bool:
	return items.has(item_id) and items[item_id] >= amount


func get_item_count(item_id: String) -> int:
	return items.get(item_id, 0)


func get_items() -> Dictionary:
	return items.duplicate()


func clear() -> void:
	items.clear()
	print("[INVENTORY] Cleared")


func debug_print_inventory() -> void:
	print("========== INVENTORY ==========")

	if items.is_empty():
		print("Inventory is empty.")
	else:
		for item_id in items:
			print(item_id, " x", items[item_id])

	print("===============================")
