class_name FoodPreparation
extends Node


@export var preparation_time: float = 3.0


var current_order: CustomerOrder = null
var preparing: bool = false


signal food_ready(order: CustomerOrder)


func start_preparing(order: CustomerOrder) -> void:
	if preparing:
		return

	if order == null:
		return

	if order.state != CustomerOrder.OrderState.ACCEPTED:
		return

	current_order = order
	preparing = true

	order.state = CustomerOrder.OrderState.PREPARING

	print("Preparing: ", order.item_name)

	await get_tree().create_timer(preparation_time).timeout

	if current_order != order:
		return

	order.state = CustomerOrder.OrderState.READY

	preparing = false

	print("Food ready: ", order.item_name)

	food_ready.emit(order)


func is_preparing() -> bool:
	return preparing


func get_ready_order() -> CustomerOrder:
	if current_order == null:
		return null

	if current_order.state != CustomerOrder.OrderState.READY:
		return null

	return current_order


func take_ready_order() -> void:
	if current_order == null:
		return

	if current_order.state != CustomerOrder.OrderState.READY:
		return

	print(
		"Prepared order taken: ",
		current_order.item_name
	)

	current_order = null
