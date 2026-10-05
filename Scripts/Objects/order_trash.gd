class_name OrderTrash
extends Interactable


func interact() -> void:
	var player := get_tree().get_first_node_in_group("player") as Player

	if player == null:
		print("[TRASH] Player not found")
		return

	if player.carrying_order == null:
		print("[TRASH] Player is not carrying an order")
		return

	var order: CustomerOrder = player.carrying_order

	print(
		"[TRASH] Discarding order: ",
		order.item_name
	)

	discard_order(player, order)


func discard_order(player: Player, order: CustomerOrder) -> void:
	var order_manager := get_tree().get_first_node_in_group("order_manager")

	if order_manager:
		order_manager.remove_order(order)

	order.state = CustomerOrder.OrderState.EXPIRED

	player.clear_carried_order()

	print(
		"[TRASH] Order discarded: ",
		order.item_name
	)
