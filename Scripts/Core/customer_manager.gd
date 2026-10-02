extends Node2D


@export var customer_scene: PackedScene
@export var spawn_interval: float = 5.0
@export var max_customers: int = 5

@onready var spawn_point: Marker2D = $"../CustomerSpawn"

var day_manager: CafeDayManager

func _ready() -> void:
	day_manager = get_tree().get_first_node_in_group("cafe_day_manager")

	await get_tree().create_timer(2.0).timeout

	spawn_customer()

	while true:
		await get_tree().create_timer(spawn_interval).timeout

		if get_customer_count() < max_customers:
			spawn_customer()


func spawn_customer() -> void:
	if day_manager == null:
		print("ERROR: CafeDayManager not found.")
		return

	if not day_manager.is_open():
		print("Café is closed. Customer will not spawn.")
		return

	if customer_scene == null:
		push_warning("Customer scene has not been assigned.")
		return

	# Find a table BEFORE creating the customer.
	var available_table := get_available_table()

	if available_table == null:
		print("No available table. Customer will not spawn.")
		return


	# Create the customer.
	var customer := customer_scene.instantiate() as Customer

	if customer == null:
		push_warning("Customer scene is not a Customer.")
		return


	get_parent().add_child(customer)

	customer.global_position = spawn_point.global_position

	print("Customer spawned!")


	# Reserve the table immediately.
	available_table.assign_customer(customer)

	customer.go_to_table(available_table)

	print(
		"Customer assigned to table: ",
		available_table.name
	)


func get_available_table() -> Table:
	var tables := get_tree().get_nodes_in_group("interactable")

	for node in tables:
		if not node is Table:
			continue

		var table := node as Table

		if not table.occupied:
			return table

	return null


func get_customer_count() -> int:
	return get_tree().get_nodes_in_group("customer").size()
