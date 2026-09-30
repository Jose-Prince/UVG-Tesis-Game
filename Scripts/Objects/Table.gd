class_name Table
extends Interactable

@export var customer_spot: Marker2D

var occupied: bool = false
var current_customer: Customer = null

func _ready() -> void:
	super._ready()
	interaction_radius = 80.0

func interact() -> void:
	print("Player interacted with the table!")

	if current_customer == null:
		print("Table is empty.")
		return

	if current_customer.order == null:
		print("Customer has no order yet.")
		return

	print("Customer order: ", current_customer.order.item_name)

	var order_ui := get_tree().get_first_node_in_group("order_ui")

	if order_ui != null:
		order_ui.show_order(self)

func get_customer_spot() -> Vector2:
	return customer_spot.global_position

func assign_customer(customer: Customer) -> void:
	current_customer = customer
	occupied = true

	print(
		"Table ",
		name,
		" assigned to customer ",
		customer.name
	)

func clear_customer() -> void:
	current_customer = null
	occupied = false

	print("Table ", name, " is now available.")

func deliver_order(order: CustomerOrder) -> bool:
	if current_customer == null:
		print("There is no customer at this table.")
		return false

	if current_customer.order == null:
		print("This customer has no order.")
		return false

	if order == null:
		print("Player is not carrying an order.")
		return false

	var customer_order := current_customer.order

	if customer_order.state != CustomerOrder.OrderState.READY:
		print("Customer's order is not ready.")
		return false

	if order != customer_order:
		print(
			"Wrong order! Customer wants ",
			customer_order.item_name,
			" but player has ",
			order.item_name
		)

		return false

	customer_order.state = CustomerOrder.OrderState.SERVED

	print(
		"Order delivered successfully: ",
		customer_order.item_name
	)

	return true
	
	
