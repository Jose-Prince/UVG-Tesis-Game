extends Node


signal order_created(order)
signal order_completed(order)


var pending_orders: Array[CustomerOrder] = []


func add_order(order: CustomerOrder) -> void:
	if order == null:
		return
	
	pending_orders.append(order)
	order_created.emit(order)
	
	print("Order added. Total pending orders: ", pending_orders.size())


func complete_order(order: CustomerOrder) -> void:
	if order == null:
		return
	
	if order in pending_orders:
		pending_orders.erase(order)
	
	order.completed = true
	
	order_completed.emit(order)
	
	print("Order completed. Total pending orders: ", pending_orders.size())


func get_pending_orders() -> Array[CustomerOrder]:
	return pending_orders
