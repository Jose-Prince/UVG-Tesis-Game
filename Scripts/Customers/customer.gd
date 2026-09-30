class_name Customer
extends CharacterBody2D


enum CustomerState {
	ENTERING,
	GOING_TO_TABLE,
	WAITING_FOR_ORDER,
	EATING,
	LEAVING,
	EXITED
}


@export var speed: float = 100.0

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

var target_position: Vector2
var target_table: Table = null

var state: CustomerState = CustomerState.ENTERING

var order: CustomerOrder = null

var available_orders: Array[String] = [
	"Coffee",
	"Latte",
	"Cappuccino",
	"Cake"
]


func _ready() -> void:
	add_to_group("customer")

	target_position = global_position


func _physics_process(_delta: float) -> void:
	match state:
		CustomerState.ENTERING:
			handle_entering()

		CustomerState.GOING_TO_TABLE:
			handle_going_to_table()

		CustomerState.WAITING_FOR_ORDER:
			handle_waiting_for_order()

		CustomerState.EATING:
			handle_eating()

		CustomerState.LEAVING:
			handle_leaving()

		CustomerState.EXITED:
			handle_exited()


func handle_entering() -> void:
	velocity = Vector2.ZERO


func handle_going_to_table() -> void:
	if navigation_agent.is_navigation_finished():
		velocity = Vector2.ZERO

		change_state(CustomerState.WAITING_FOR_ORDER)

		print("Customer reached table.")

		return

	var next_position := navigation_agent.get_next_path_position()
	var direction := global_position.direction_to(next_position)

	velocity = direction * speed
	move_and_slide()

func handle_waiting_for_order() -> void:
	velocity = Vector2.ZERO

	if order == null:
		create_order()


func handle_eating() -> void:
	velocity = Vector2.ZERO


func handle_leaving() -> void:
	velocity = Vector2.ZERO


func handle_exited() -> void:
	velocity = Vector2.ZERO


func change_state(new_state: CustomerState) -> void:
	if state == new_state:
		return

	print(
		"Customer ",
		name,
		": ",
		CustomerState.keys()[state],
		" -> ",
		CustomerState.keys()[new_state]
	)

	state = new_state


func move_to(position: Vector2) -> void:
	target_position = position

	await get_tree().physics_frame

	navigation_agent.target_position = position


func go_to_table(table: Table) -> void:
	target_table = table

	change_state(CustomerState.GOING_TO_TABLE)

	move_to(table.get_customer_spot())

func create_order() -> void:
	var selected_item = available_orders.pick_random()

	order = CustomerOrder.new(selected_item)

	print("Customer ", name, " ordered: ", order.item_name)
