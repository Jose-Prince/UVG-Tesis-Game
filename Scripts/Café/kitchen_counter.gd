extends Interactable


@export var food_visual_scene: PackedScene


var food_preparation: FoodPreparation
var order_manager: OrderManager

var current_food_visual: FoodVisual = null


@onready var food_position: Marker2D = $FoodPosition


func _ready() -> void:
	super._ready()

	food_preparation = get_tree().get_first_node_in_group("food_preparation")
	order_manager = get_tree().get_first_node_in_group("order_manager")

	if food_preparation != null:
		food_preparation.food_ready.connect(_on_food_ready)


func interact() -> void:
	print("Player interacted with kitchen counter.")

	if food_preparation == null:
		print("FoodPreparation system not found.")
		return

	if order_manager == null:
		print("OrderManager system not found.")
		return

	var player := get_tree().get_first_node_in_group("player") as Player

	if player == null:
		print("Player not found.")
		return


	# 1. Check if there is a finished order to pick up.
	var ready_order := food_preparation.get_ready_order()

	if ready_order != null:

		player.pick_up_order(ready_order)

		if player.is_carrying_order():
			remove_food_visual()

			food_preparation.take_ready_order()
			order_manager.remove_order(ready_order)

		return


	# 2. Check if kitchen is currently preparing.
	if food_preparation.is_preparing():
		print("Food is still being prepared.")
		return


	# 3. Get next order from queue.
	var next_order := order_manager.get_next_order()

	if next_order == null:
		print("There are no orders waiting in the queue.")
		return


	# 4. Start preparing.
	food_preparation.start_preparing(next_order)


func _on_food_ready(order: CustomerOrder) -> void:
	print("KitchenCounter received food_ready signal.")

	show_food_visual(order)


func show_food_visual(order: CustomerOrder) -> void:
	if order == null:
		print("ERROR: Cannot show food for null order.")
		return

	if current_food_visual != null:
		print("Food visual already exists.")
		return

	if food_visual_scene == null:
		print("ERROR: FoodVisual scene is not assigned.")
		return

	if food_position == null:
		print("ERROR: FoodPosition was not found.")
		return

	print("Creating food visual for: ", order.item_name)

	current_food_visual = food_visual_scene.instantiate() as FoodVisual

	if current_food_visual == null:
		print("ERROR: Could not create FoodVisual.")
		return

	get_parent().add_child(current_food_visual)

	current_food_visual.global_position = food_position.global_position

	current_food_visual.setup(order)

	print(
		"Food visual spawned at: ",
		food_position.global_position
	)


func remove_food_visual() -> void:
	if current_food_visual == null:
		return

	current_food_visual.queue_free()
	current_food_visual = null

	print("Food visual removed.")
