extends Node2D


@export var customer_scene: PackedScene
@export var spawn_interval: float = 5.0
@export var max_customers: int = 5

@onready var spawn_point: Marker2D = $"../CustomerSpawn"


func _ready() -> void:
	await get_tree().create_timer(2.0).timeout

	spawn_customer()

	while true:
		await get_tree().create_timer(spawn_interval).timeout

		if get_customer_count() < max_customers:
			spawn_customer()


func spawn_customer() -> void:
	if customer_scene == null:
		push_warning("Customer scene has not been assigned.")
		return

	var customer := customer_scene.instantiate() as Customer

	if customer == null:
		push_warning("Customer scene is not a Customer.")
		return

	get_parent().add_child(customer)

	customer.global_position = spawn_point.global_position

	print("Customer spawned!")

	assign_table(customer)


func assign_table(customer: Customer) -> void:
	var tables := get_tree().get_nodes_in_group("interactable")

	for node in tables:
		if node is Table:
			var table := node as Table

			if not table.occupied:
				table.assign_customer(customer)
				customer.go_to_table(table)

				print("Customer assigned to table: ", table.name)

				return

	print("No available table found.")

func get_customer_count() -> int:
	return get_tree().get_nodes_in_group("customer").size()
