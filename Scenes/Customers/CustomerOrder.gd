class_name CustomerOrder
extends RefCounted


var items: Array[MenuItem] = []
var total: float = 0.0
var completed: bool = false


func add_item(item: MenuItem) -> void:
	items.append(item)
	total += item.price


func get_item_count() -> int:
	return items.size()
