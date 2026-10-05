class_name OrderManager
extends Node


var order_queue: Array[CustomerOrder] = []


func _ready() -> void:
	add_to_group("order_manager")


func add_order(order: CustomerOrder) -> void:
	if order == null:
		return

	if order.state != CustomerOrder.OrderState.ACCEPTED:
		return

	if order_queue.has(order):
		return

	order_queue.append(order)

	print(
		"Order added to queue: ",
		order.item_name,
		" | Queue size: ",
		order_queue.size()
	)


func get_next_order() -> CustomerOrder:
	while not order_queue.is_empty():
		var order := order_queue[0]

		if order == null:
			order_queue.pop_front()
			continue

		if order.state != CustomerOrder.OrderState.ACCEPTED:
			order_queue.pop_front()
			continue

		return order

	return null


func remove_order(order: CustomerOrder) -> void:
	if order == null:
		return

	order_queue.erase(order)

	print(
		"Order removed from queue: ",
		order.item_name,
		" | Queue size: ",
		order_queue.size()
	)


func complete_order(order: CustomerOrder) -> void:
	if order == null:
		return

	if order.state == CustomerOrder.OrderState.COMPLETED:
		return

	if order.state != CustomerOrder.OrderState.SERVED:
		return

	order.state = CustomerOrder.OrderState.COMPLETED

	PlayerData.add_money(order.price)

	remove_order(order)

	print(
		"Order completed: ",
		order.item_name,
		" | Earned: $",
		order.price,
		" | Current money: $",
		PlayerData.money
	)


func get_queue_size() -> int:
	return order_queue.size()
