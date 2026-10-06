extends CanvasLayer


@onready var panel: Panel = $Panel
@onready var order_manager: OrderManager
@onready var order_label: Label = $Panel/MarginContainer/VBoxContainer/OrderLabel
@onready var accept_button: Button = $Panel/MarginContainer/VBoxContainer/AcceptButton


var current_table: Table = null
var current_customer: Customer = null


func _ready() -> void:
	panel.visible = false

	accept_button.pressed.connect(_on_accept_order_pressed)

	order_manager = get_tree().get_first_node_in_group("order_manager")


func show_order(table: Table, customer: Customer) -> void:
	if table == null:
		return

	if customer == null:
		return

	if customer.order == null:
		return

	current_table = table
	current_customer = customer

	order_label.text = "Order: " + customer.order.item_name

	update_button()

	panel.visible = true


func update_button() -> void:
	if current_customer == null:
		return

	if current_customer.order == null:
		return

	var order := current_customer.order

	match order.state:
		CustomerOrder.OrderState.WAITING:
			accept_button.text = "Take Order"
			accept_button.disabled = false

		CustomerOrder.OrderState.ACCEPTED:
			accept_button.text = "Order Taken"
			accept_button.disabled = true

		_:
			accept_button.disabled = true


func _on_accept_order_pressed() -> void:
	if current_customer == null:
		return

	if current_customer.order == null:
		return

	var order := current_customer.order

	if order.state != CustomerOrder.OrderState.WAITING:
		return

	order.state = CustomerOrder.OrderState.ACCEPTED

	print(
		"Order accepted from ",
		current_customer.name,
		": ",
		order.item_name
	)

	if order_manager != null:
		order_manager.add_order(order)
	else:
		print("ERROR: OrderManager not found.")

	update_button()
