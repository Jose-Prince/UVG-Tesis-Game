class_name Table
extends Interactable


@export var seats: Array[TableSeat] = []

var current_food_visual: FoodVisual = null

@export var food_visual_scene: PackedScene

@onready var food_position: Marker2D = $FoodPosition


func _ready() -> void:
	super._ready()

	interaction_radius = 20.0

	add_to_group("furniture")

	# Automatically find all TableSeat nodes.
	seats.clear()

	var seat_nodes := find_children("*", "TableSeat", true, false)

	for node in seat_nodes:
		var seat := node as TableSeat

		if seat != null:
			seats.append(seat)

	print(
		"[TABLE] ",
		name,
		" found ",
		seats.size(),
		" seats."
	)


# -----------------------------------------
# Interaction
# -----------------------------------------

func interact() -> void:
	print("Player interacted with the table!")

	var customer := get_customer_closest_to_player()

	if customer == null:
		print("No customer at this table.")
		return

	if customer.order == null:
		print(
			"Customer ",
			customer.name,
			" has no order yet."
		)

		return

	print(
		"Customer ",
		customer.name,
		" order: ",
		customer.order.item_name
	)

	var order_ui := get_tree().get_first_node_in_group("order_ui")

	if order_ui != null:
		order_ui.show_order(self, customer)


func get_customer_closest_to_player() -> Customer:
	var player := get_tree().get_first_node_in_group(
		"player"
	) as Player

	if player == null:
		print("ERROR: Player not found.")
		return null

	var closest_customer: Customer = null
	var closest_distance: float = INF

	for seat in seats:
		if seat == null:
			continue

		var customer := seat.current_customer

		if customer == null:
			continue

		if not is_instance_valid(customer):
			continue

		var distance := player.global_position.distance_to(
			customer.global_position
		)

		if distance < closest_distance:
			closest_distance = distance
			closest_customer = customer

	return closest_customer


# -----------------------------------------
# Seats
# -----------------------------------------

func get_available_seat() -> TableSeat:
	for seat in seats:
		if seat == null:
			continue

		if seat.is_available():
			return seat

	return null


func has_available_seat() -> bool:
	return get_available_seat() != null


func get_available_seat_count() -> int:
	var count := 0

	for seat in seats:
		if seat == null:
			continue

		if seat.is_available():
			count += 1

	return count


func assign_customer(customer: Customer) -> TableSeat:
	if customer == null:
		return null

	var seat := get_available_seat()

	if seat == null:
		print(
			"Table ",
			name,
			" has no available seats."
		)

		return null

	seat.assign_customer(customer)

	print(
		"Table ",
		name,
		" assigned seat ",
		seat.name,
		" to customer ",
		customer.name
	)

	return seat


func clear_customer(customer: Customer) -> void:
	for seat in seats:
		if seat == null:
			continue

		if seat.current_customer == customer:
			seat.clear_customer()

			print(
				"Table ",
				name,
				" released seat ",
				seat.name
			)

			return


func get_customer_spot(seat: TableSeat) -> Vector2:
	if seat == null:
		return global_position

	return seat.global_position


func get_active_customer() -> Customer:
	for seat in seats:
		if seat == null:
			continue

		if seat.current_customer != null:
			return seat.current_customer

	return null


func get_customer_count() -> int:
	var count := 0

	for seat in seats:
		if seat == null:
			continue

		if seat.current_customer != null:
			count += 1

	return count


# -----------------------------------------
# Order delivery
# -----------------------------------------

func deliver_order(order: CustomerOrder) -> bool:
	if order == null:
		print("Player is not carrying an order.")
		return false

	var customer := get_customer_with_order(order)

	if customer == null:
		print(
			"No customer at table wants order: ",
			order.item_name
		)

		return false

	var customer_order := customer.order

	if customer_order == null:
		print("This customer has no order.")
		return false

	if customer_order.state != CustomerOrder.OrderState.READY:
		print(
			"Customer's order is not ready. State: ",
			customer_order.state
		)

		return false

	if order != customer_order:
		print(
			"Wrong order! Customer wants ",
			customer_order.item_name,
			" but player has ",
			order.item_name
		)

		return false

	# -----------------------------------------
	# Order is correct
	# -----------------------------------------

	customer_order.state = CustomerOrder.OrderState.SERVED

	customer.stop_patience_timer()

	print(
		"Order matched to customer: ",
		customer.name
	)

	# -----------------------------------------
	# Add money
	# -----------------------------------------

	var economy := get_tree().get_first_node_in_group(
		"cafe_economy"
	)

	if economy != null:
		economy.add_money(customer_order.price)
	else:
		print("ERROR: CafeEconomy not found.")

	# -----------------------------------------
	# Remove food from player
	# -----------------------------------------

	var player := get_tree().get_first_node_in_group(
		"player"
	) as Player

	if player != null:
		player.remove_carried_food_visual()

	# -----------------------------------------
	# Show food on table
	# -----------------------------------------

	show_food_visual(customer_order)

	print(
		"Order delivered successfully: ",
		customer_order.item_name,
		" to ",
		customer.name
	)

	return true


func get_customer_with_order(
	order: CustomerOrder
) -> Customer:

	if order == null:
		return null

	for seat in seats:
		if seat == null:
			continue

		var customer := seat.current_customer

		if customer == null:
			continue

		if not is_instance_valid(customer):
			continue

		if customer.order == order:
			return customer

	return null


# -----------------------------------------
# Food visual
# -----------------------------------------

func show_food_visual(order: CustomerOrder) -> void:
	if order == null:
		return

	if food_visual_scene == null:
		print(
			"ERROR: FoodVisual scene is not assigned to Table."
		)

		return

	if food_position == null:
		print(
			"ERROR: FoodPosition was not found on Table."
		)

		return

	if current_food_visual != null:
		return

	current_food_visual = (
		food_visual_scene.instantiate() as FoodVisual
	)

	if current_food_visual == null:
		print(
			"ERROR: Could not create FoodVisual for Table."
		)

		return

	get_parent().add_child(current_food_visual)

	current_food_visual.global_position = (
		food_position.global_position
	)

	current_food_visual.setup(order)

	print(
		"Food placed on table: ",
		order.item_name
	)


func remove_food_visual() -> void:
	if current_food_visual == null:
		return

	current_food_visual.queue_free()
	current_food_visual = null

	print("Food removed from table.")
