extends Interactable


var food_preparation: FoodPreparation


func _ready() -> void:
	super._ready()

	food_preparation = get_tree().get_first_node_in_group("food_preparation")


func interact() -> void:
	print("Player interacted with kitchen counter.")

	if food_preparation == null:
		print("FoodPreparation system not found.")
		return

	var player = get_tree().get_first_node_in_group("player") as Player

	if player == null:
		print("Player not found.")
		return

	# Player is already carrying something.
	if player.is_carrying_order():
		print("Player is already carrying food.")
		return

	# First priority: pick up ready food.
	var ready_order := food_preparation.get_ready_order()

	if ready_order != null:
		player.pick_up_order(ready_order)
		food_preparation.take_ready_order()

		return

	# If food is currently being prepared, do nothing.
	if food_preparation.is_preparing():
		print("Food is still being prepared.")
		return

	# Otherwise, look for an accepted order.
	var accepted_order := find_accepted_order()

	if accepted_order == null:
		print("There are no accepted orders.")
		return

	food_preparation.start_preparing(accepted_order)


func find_accepted_order() -> CustomerOrder:
	for customer_node in get_tree().get_nodes_in_group("customer"):
		if not customer_node is Customer:
			continue

		var customer := customer_node as Customer

		if customer.order == null:
			continue

		if customer.order.state == CustomerOrder.OrderState.ACCEPTED:
			return customer.order

	return null
