class_name Table
extends Interactable

@export var customer_spot: Marker2D
var current_food_visual: FoodVisual = null

@export var food_visual_scene: PackedScene

@onready var food_position: Marker2D = $FoodPosition
var occupied: bool = false
var current_customer: Customer = null

func _ready() -> void:
	super._ready()
	interaction_radius = 80.0
	add_to_group("furniture")

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


	# -----------------------------------------
	# Order is correct
	# -----------------------------------------

	customer_order.state = CustomerOrder.OrderState.SERVED

	current_customer.stop_patience_timer()


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
		customer_order.item_name
	)

	return true
		
	
func show_food_visual(order: CustomerOrder) -> void:
	if order == null:
		return

	if food_visual_scene == null:
		print("ERROR: FoodVisual scene is not assigned to Table.")
		return

	if food_position == null:
		print("ERROR: FoodPosition was not found on Table.")
		return

	if current_food_visual != null:
		return

	current_food_visual = food_visual_scene.instantiate() as FoodVisual

	if current_food_visual == null:
		print("ERROR: Could not create FoodVisual for Table.")
		return

	get_parent().add_child(current_food_visual)

	current_food_visual.global_position = food_position.global_position

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
