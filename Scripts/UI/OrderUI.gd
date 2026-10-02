extends CanvasLayer


@onready var panel: Panel = $Panel
@onready var order_label: Label = $Panel/OrderLabel
@onready var accept_button: Button = $Panel/AcceptButton
@onready var order_manager: OrderManager


var current_table: Table = null


func _ready() -> void:
	panel.visible = false
	accept_button.pressed.connect(_on_accept_order_pressed)

	order_manager = get_tree().get_first_node_in_group("order_manager")


func show_order(table: Table) -> void:
	if table.current_customer == null:
		return

	var customer := table.current_customer

	if customer.order == null:
		return

	current_table = table

	order_label.text = "Order: " + customer.order.item_name

	update_button()

	panel.visible = true


func update_button() -> void:
	if current_table == null:
		return

	var order := current_table.current_customer.order

	if order == null:
		return

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
	if current_table == null:
		return

	var customer := current_table.current_customer

	if customer == null:
		return

	if customer.order == null:
		return

	var order := customer.order

	if order.state != CustomerOrder.OrderState.WAITING:
		return

	order.state = CustomerOrder.OrderState.ACCEPTED

	print("Order accepted: ", order.item_name)

	if order_manager != null:
		order_manager.add_order(order)
	else:
		print("ERROR: OrderManager not found.")

	update_button()
