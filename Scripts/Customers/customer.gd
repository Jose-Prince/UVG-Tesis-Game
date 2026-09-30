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
@export var eating_time: float = 5.0

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

var target_position: Vector2
var target_table: Table = null

var state: CustomerState = CustomerState.ENTERING

var order: CustomerOrder = null
var exit_position: Vector2
var leaving_initialized: bool = false

var available_orders: Array[String] = [
	"Coffee",
	"Latte",
	"Cappuccino",
	"Cake"
]


func _ready() -> void:
	add_to_group("customer")
	target_position = global_position

	var exit_marker := get_tree().get_first_node_in_group("customer_exit")

	if exit_marker != null:
		exit_position = exit_marker.global_position
		print("Customer exit found at: ", exit_position)
	else:
		print("ERROR: CustomerExit was not found.")

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
		return

	if order.state == CustomerOrder.OrderState.SERVED:
		change_state(CustomerState.EATING)


func handle_eating() -> void:
	velocity = Vector2.ZERO

	await get_tree().create_timer(eating_time).timeout

	if state != CustomerState.EATING:
		return

	change_state(CustomerState.LEAVING)

func handle_leaving() -> void:
	if not leaving_initialized:
		velocity = Vector2.ZERO
		return

	if navigation_agent.is_navigation_finished():
		velocity = Vector2.ZERO

		if target_table != null:
			target_table.clear_customer()

		change_state(CustomerState.EXITED)

		return

	var next_position := navigation_agent.get_next_path_position()
	var direction := global_position.direction_to(next_position)

	velocity = direction * speed
	move_and_slide()

func handle_exited() -> void:
	velocity = Vector2.ZERO

	print("Customer ", name, " left the café.")

	queue_free()


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

	if state == CustomerState.LEAVING:
		leaving_initialized = false
		start_leaving()

func start_leaving() -> void:
	if exit_position == Vector2.ZERO:
		print("ERROR: Customer exit position was not found.")
		return

	navigation_agent.target_position = exit_position

	await get_tree().physics_frame

	leaving_initialized = true

	print("Customer leaving toward: ", exit_position)

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
