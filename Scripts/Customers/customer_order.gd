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
var state: OrderState = OrderState.WAITING


func _init(item: String) -> void:
	item_name = item
