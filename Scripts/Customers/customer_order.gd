class_name CustomerOrder
extends RefCounted


enum OrderState {
	WAITING,
	ACCEPTED,
	PREPARING,
	READY,
	SERVED,
	EXPIRED,
	COMPLETED
}


var item_name: String
var price: float
var state: OrderState = OrderState.WAITING


func _init(item: String) -> void:
	item_name = item
	price = get_item_price(item)


func get_item_price(item: String) -> float:
	match item:
		"Coffee":
			return 5.0

		"Latte":
			return 7.0

		"Cappuccino":
			return 8.0

		"Cake":
			return 6.0

		_:
			return 5.0
